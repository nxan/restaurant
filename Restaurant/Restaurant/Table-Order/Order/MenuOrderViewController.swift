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
    let URL_ORDER = "http://localhost:8888/order/"
    let URL_ORDER_DETAIL = "http://localhost:8888/orderdetail/"
    
    let cellId = "MenuCell"
    let time = Date()
    var desk: Desk!
    var flagUpdated = false
    
    var menu: [Menu] = []
    var filterMenu: [Menu] = []
    var cart: [Cart] = []
    var menuJSON: [[String: Any]] = [[String: Any]]()
    var textArray : [[String: Any]] = [[String: Any]]()
    var attributedStringItems: [NSAttributedString] = []
    var selectedAttributedStringItems: [NSAttributedString] = []
    var countItemCart: Int = 0
    var flag = false
    var flagRemove = false
    
    
    var defaultAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
    
    var selectedAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xF93C64)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.delegate = self
        
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        labelTime.text = "\(time.hour):\(minute)"
        labelDesk.text = desk.deskName
        
        countItemCart = desk.quantity
        buttonBasket.badgeString = String(countItemCart)
        
        generateGroupFood()
        generateFood(group: 1)
        
        
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
        
        print(cart)
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
            UserDefaults.standard.set(true, forKey: "flagAddCart")
            
            if(self.desk.enable) {
                if let value = UserDefaults.standard.value(forKey: "flagAddCart") {
                    let flagAdd = value as! Bool
                    if(flagAdd && !self.flagRemove) {
                        self.cart.removeAll()
                        self.flagRemove = true
                    }
                }
                Alamofire.request(self.URL_ORDER_DETAIL + "getOne/\(self.desk.deskId)", method: .get, encoding: JSONEncoding.default).responseJSON
                    { (response) in
                        if let responseValue = response.result.value as! [String: Any]? {
                            if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                                if(!self.flag) {
                                    for item in responseOrder {
                                        self.cart.append(Cart(id: item["MaMon"] as! Int, name: item["TenMon"] as! String, quantity: item["SoLuong"] as! Int, price: item["DonGiaBan"] as! Double, updated: false))
                                    }
                                    self.flag = true
                                }
                                let newCart = Cart(id: self.filterMenu[indexPath.row].productId, name: self.filterMenu[indexPath.row].name, quantity: 1, price: self.filterMenu[indexPath.row].price, updated: false)
                                if let oldCartIndex = self.cart.firstIndex(where: { $0.id == newCart.id }) {
                                    var cartIndex = self.cart[oldCartIndex]
                                    cartIndex.quantity += 1
                                    cartIndex.updated = true
                                    self.cart[oldCartIndex] = cartIndex
                                    
                                } else {
                                    self.cart.append(newCart)
                                }
                                self.flagUpdated = true
                            }
                        }
                }
            } else {
                let newCart = Cart(id: self.filterMenu[indexPath.row].productId, name: self.filterMenu[indexPath.row].name, quantity: 1, price: self.filterMenu[indexPath.row].price, updated: false)
                if let oldCartIndex = self.cart.firstIndex(where: { $0.id == newCart.id }) {
                    var cart = self.cart[oldCartIndex]
                    cart.quantity += 1
                    self.cart[oldCartIndex] = cart
                } else {
                    self.cart.append(newCart)
                }
                self.flagUpdated = false
            }
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
            viewController.desk = desk
            viewController.menu = filterMenu[row]
            viewController.cart = cart
            viewController.countItemCart = countItemCart
            viewController.flagUpdated = flagUpdated
        }
        if segue.identifier == "showCart" {
            let viewController = segue.destination as? CartViewController
            viewController?.desk = desk
            viewController?.cart = cart
            viewController?.countItemCart = countItemCart
            viewController?.flagUpdated = flagUpdated
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
