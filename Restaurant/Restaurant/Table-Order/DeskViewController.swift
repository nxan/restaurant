//
//  FirstViewController.swift
//  Restaurant
//
//  Created by NXA on 5/1/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import JNSegmentedControl
import Alamofire


private let itemHeight: CGFloat = 87
private let lineSpacing: CGFloat = 20
private let xInset: CGFloat = 20
private let topInset: CGFloat = 10

class DeskViewController: UIViewController {
    
    let url = Server.init().url
    lazy var URL_DESK = url + "desk/"
    lazy var URL_PLACE = url + "place/"
    lazy var URL_ORDER = url + "order/"
    
    @IBOutlet var segmentedControlView: JNSegmentedCollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let cellId = "DeskCell"
    var desks: [Desk] = []
    var deskJSON: [[String: Any]] = [[String: Any]]()
    var textArray : [[String: Any]] = [[String: Any]]()
    var attributedStringItems: [NSAttributedString] = []
    var selectedAttributedStringItems: [NSAttributedString] = []
    var deskPlace = ""
    var arrayPlace: [Int] = []
    

    var defaultAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
    
    var selectedAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xF93C64)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateFloor(floor: 1)
        if !Connectivity.isConnectedToInternet() {
            alert(title: "Lỗi mạng", message: "Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.")
        }
        print(UserDefaults.standard.string(forKey: "key_email")!)
    }
    
    class Connectivity {
        class func isConnectedToInternet() -> Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initIndicator()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if let value = UserDefaults.standard.value(forKey: "chooseSegmentedControl") {
            let selectedIndex = value as! Int
            generateFloor(floor: selectedIndex + 1)
        }
       generatePlace()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(segmentedControlView.selectedIndex, forKey: "chooseSegmentedControl")
    }
    
    func generatePlace() {
        self.arrayPlace.removeAll()
        self.attributedStringItems.removeAll()
        self.selectedAttributedStringItems.removeAll()
        Alamofire.request(URL_PLACE, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                self.stopIndicator()
                if let responseValue = response.result.value as! [String: Any]? {
                    print(response)
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        self.textArray = responseOrder
                        for item in self.textArray {
                            let defaultAttributedString = NSAttributedString(string: item["TenKhu"] as! String, attributes: self.defaultAttributes)
                            self.attributedStringItems.append(defaultAttributedString)
                            
                            let selectedAttributedString = NSAttributedString(string: item["TenKhu"] as! String, attributes: self.selectedAttributes)
                            self.selectedAttributedStringItems.append(selectedAttributedString)
                            self.arrayPlace.append(item["MaKhu"] as! Int)
                            self.segmentedControlView.valueDidChange = { segmentIndex in
                                self.initIndicator()
                                self.generateFloor(floor: self.arrayPlace[segmentIndex])
                            }
                        }
                        self.showSegmentedControlView()
                    }
                }
        }
    }
    
    func generateFloor(floor: Int) {
        desks.removeAll()
        Alamofire.request(URL_DESK + "\(floor)", method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                self.stopIndicator()
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        self.deskJSON = responseOrder
                        for desk in self.deskJSON {
                            self.desks.append(Desk(deskId: desk["MaBan"] as! Int, deskName: desk["TenBan"] as! String, enable: (desk["HienThi"]) as! Bool, place: desk["Khu"] as! Int, quantity: desk["TongMon"] as! Int, timeOn: desk["GIOVAO"] as! String))
                        }
                        self.initDeskCollection(desks: self.desks)
                    }
                }
            }
    }
    
    
    func initDeskCollection(desks: [Desk]) {
        let nib = UINib(nibName: cellId, bundle: nil)
        self.desks = desks
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset.bottom = itemHeight
        configureCollectionViewLayout()
        collectionView.reloadData()
    }
    
    func showSegmentedControlView(){
        
        let verticalSeparatorOptions = JNSegmentedCollectionItemVerticalSeparatorOptions(heigthRatio: 0.6, width: 2.0, color: UIColor.lightGray)
        
        let options = JNSegmentedCollectionOptions(backgroundColor: .clear, layoutType: JNSegmentedCollectionLayoutType.dynamic, verticalSeparatorOptions: verticalSeparatorOptions, scrollEnabled: true)
        
        self.segmentedControlView.setup(items: self.attributedStringItems, selectedItems: self.selectedAttributedStringItems, options: options)
    }
    
    private func configureCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func alert(title: String, message: String) {
        self.stopIndicator()
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

extension DeskViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DeskCell
        let desk = desks[indexPath.row]
        cell.configureWith(desk)        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deskJSON.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller =  self.storyboard!.instantiateViewController(withIdentifier: "toMenuOrder") as! MenuOrderViewController
        controller.desk = desks[indexPath.row]
        self.navigationController?.pushViewController(controller, animated:true)
    }
    
    
}
