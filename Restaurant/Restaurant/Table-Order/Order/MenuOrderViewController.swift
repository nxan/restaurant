//
//  MenuOrderViewController.swift
//  Restaurant
//
//  Created by NXA on 5/4/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import JNSegmentedControl
import MIBadgeButton_Swift
import Alamofire

class MenuOrderViewController: UIViewController {
    
    @IBOutlet var segmentedControlView: JNSegmentedCollectionView!
    @IBOutlet weak var buttonBasket: MIBadgeButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var labelDesk: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    
    let URL_GROUP_FOOD = "http://localhost:8888/group_food/"
    let URL_FOOD = "http://localhost:8888/food/"
    
    let cellId = "MenuCell"
    let time = Date()
    var deskId = 0
    var deskName = ""
    
    var menu: [Menu] = []
    var filterMenu: [Menu] = []
    var cart: [Cart] = []
    var menuJSON: [[String: Any]] = [[String: Any]]()
    var textArray : [[String: Any]] = [[String: Any]]()
    var attributedStringItems: [NSAttributedString] = []
    var selectedAttributedStringItems: [NSAttributedString] = []
    var countItemCart: Int = 0
    
    
    var defaultAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
    
    var selectedAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xF93C64)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.delegate = self
        
        buttonBasket.badgeString = String(countItemCart)
        generateGroupFood()
        generateFood(group: 1)
        
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        labelTime.text = "\(time.hour):\(minute)"
        
        labelDesk.text = deskName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.segmentedControlView.valueDidChange = { segmentIndex in
            if (segmentIndex == 0) { self.generateFood(group: 1) }
            if (segmentIndex == 1) { self.generateFood(group: 2) }
            if (segmentIndex == 2) { self.generateFood(group: 3) }
            if (segmentIndex == 3) { self.generateFood(group: 4) }
            self.filterMenu = self.menu
            self.tableView.reloadData()
        }
        self.buttonBasket.badgeString = String(self.countItemCart)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
               
    func generateGroupFood() {
        Alamofire.request(URL_GROUP_FOOD, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        self.textArray = responseOrder
                        for item in self.textArray {
                            let defaultAttributedString = NSAttributedString(string: item["TenNhom"] as! String, attributes: self.defaultAttributes)
                            self.attributedStringItems.append(defaultAttributedString)
                            
                            let selectedAttributedString = NSAttributedString(string: item["TenNhom"] as! String, attributes: self.selectedAttributes)
                            self.selectedAttributedStringItems.append(selectedAttributedString)
                        }
                        self.showSegmentedControlView()
                    }
                }
        }
    }
    
    func generateFood(group: Int) {
        menu.removeAll()
        Alamofire.request(URL_FOOD + "\(group)", method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        self.menuJSON = responseOrder
                        for item in self.menuJSON {
                            self.menu.append(Menu(productId: item["MaMon"] as! Int, name: item["TenMon"] as! String, stock: item["DonVi"] as! Int, price: item["DonGiaBan"] as! Double))
                        }
                        self.filterMenu = self.menu                        
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    func showSegmentedControlView() {
        
        let verticalSeparatorOptions = JNSegmentedCollectionItemVerticalSeparatorOptions(heigthRatio: 0.6, width: 2.0, color: UIColor.lightGray)
        
        let options = JNSegmentedCollectionOptions(backgroundColor: .clear, layoutType: JNSegmentedCollectionLayoutType.dynamic, verticalSeparatorOptions: verticalSeparatorOptions, scrollEnabled: true)
        
        self.segmentedControlView.setup(items: self.attributedStringItems, selectedItems: self.selectedAttributedStringItems, options: options)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}

extension MenuOrderViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MenuCell", owner: self, options: nil)?.first as! MenuCell
        cell.configureWith(filterMenu[indexPath.row])
        cell.btnAdd = {
            self.countItemCart += 1
            self.buttonBasket.badgeString = String(self.countItemCart)
            
            let newCart = Cart(id: self.filterMenu[indexPath.row].productId, name: self.filterMenu[indexPath.row].name, quantity: 1, price: self.filterMenu[indexPath.row].price)
            if let oldCartIndex = self.cart.firstIndex(where: { $0.id == newCart.id }) {
                var cart = self.cart[oldCartIndex]
                cart.quantity += 1
                self.cart[oldCartIndex] = cart
            } else {
                self.cart.append(newCart)
            }
            print(self.cart)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMenuDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MenuContainerViewController,
            segue.identifier == "showMenuDetail" {
            let row = (sender as! IndexPath).row
            viewController.productName = filterMenu[row].name
            viewController.price = filterMenu[row].price
            viewController.productId = filterMenu[row].productId
            viewController.cart = cart
            viewController.countItemCart = countItemCart
            viewController.deskId = deskId
            viewController.deskName = deskName
        }
        if segue.identifier == "showCart" {
            let viewController = segue.destination as? CartViewController
            viewController?.cart = cart
            viewController?.countItemCart = countItemCart
            viewController?.deskId = deskId
            viewController?.deskName = deskName
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMenu = menu.filter { index in
            if(searchText == "") {
                return true
            }
            return index.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        filterMenu = menu
        tableView.reloadData()
    }

    
}
