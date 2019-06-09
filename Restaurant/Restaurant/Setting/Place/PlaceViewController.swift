//
//  PlaceViewController.swift
//  Restaurant
//
//  Created by NXA on 6/8/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class PlaceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = Server.init().url
    lazy var URL_PLACE = url + "place"
    var placeTextField: UITextField!
    
    var place: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonAdd = UIBarButtonItem(title: "Thêm", style: .plain, target: self, action: #selector(PlaceViewController.clickAdd))
        self.navigationItem.rightBarButtonItem = buttonAdd
        findAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func clickAdd(){
        let alertController = UIAlertController(title: "Nhập khu vực", message: "Vui lòng nhập khu vực bạn muốn thêm", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: feeTextField)
        let okAction = UIAlertAction(title: "Xác nhận", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func feeTextField(textField: UITextField!) {
        placeTextField = textField
        placeTextField.placeholder = "Ví dụ: Tầng 1, Tầng 2..."
        placeTextField.autocapitalizationType = .sentences
    }
    
    func okHandler(alert: UIAlertAction) {
        createPlace(placeName: placeTextField.text!)
    }
  
    func findAll() {
        place.removeAll()
        Alamofire.request(URL_PLACE, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.place.append(Place(placeId: item["MaKhu"] as! Int, placeName: item["TenKhu"] as! String))
                        }
                        self.tableView.reloadData()  
                    }
                }
        }
    }
    
    func createPlace(placeName: String) {
        let parameters = [
            "TenKhu": placeName,
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_PLACE)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                self.findAll()
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func deletePlace(placeId: Int) {
        let parameters = [
            :] as Dictionary<String, Any>
        var request = URLRequest(url: URL(string: URL_PLACE + "/\(placeId)")!)
        request.httpMethod = "DELETE"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                self.findAll()
            } catch {
                print("error")
                self.alert(title: "Có lỗi xảy ra trong quá trình xóa", message: "Bạn không thể xóa khu vực đang được sử dụng")
            }
        })
        task.resume()
    }
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension PlaceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PlaceTableViewCell", owner: self, options: nil)?.first as! PlaceTableViewCell
        cell.configureWith(place[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deletePlace(placeId: place[indexPath.row].placeId)
        }
    }
    
}
