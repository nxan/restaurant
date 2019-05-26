//
//  MenuDetailViewController.swift
//  Restaurant
//
//  Created by NXA on 5/7/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class MenuDetailViewController: UITableViewController {
    
    let URL_ORDER_DETAIL = "http://localhost:8888/orderdetail/"
    
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var labelCount: UILabel!
    @IBAction func stpperCount(_ sender: UIStepper) {
        labelCount.text = Int(sender.value).description
    }
    
    var type = ["Nóng", "Lạnh"]
    var selectItem: String?
    var cart: [Cart] = []
    var countItemCart: Int = 0
    var desk: Desk!
    var menu: Menu!
    var flagUpdated = false
    
    @IBAction func btnAddProduct(_ sender: Any) {
        
        if(self.desk.enable) {
            if let value = UserDefaults.standard.value(forKey: "flagAddCart") {
                let flagAdd = value as! Bool
                if(flagAdd) {
                    self.cart.removeAll()
                }
            }
            Alamofire.request(self.URL_ORDER_DETAIL + "getOne/\(self.desk.deskId)", method: .get, encoding: JSONEncoding.default).responseJSON
                { (response) in
                    if let responseValue = response.result.value as! [String: Any]? {
                        if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                            for item in responseOrder {
                                self.cart.append(Cart(id: item["MaMon"] as! Int, name: item["TenMon"] as! String, quantity: item["SoLuong"] as! Int, price: item["DonGiaBan"] as! Double, updated: false))
                            }
                            let newCart = Cart(id: self.menu.productId, name: self.txtProductName.text!, quantity: Int(self.labelCount.text!)!, price: self.menu.price, updated: false)
                            if let oldCartIndex = self.cart.firstIndex(where: { $0.id == newCart.id }) {
                                var cart = self.cart[oldCartIndex]
                                cart.quantity += Int(self.labelCount.text!)!
                                self.countItemCart += Int(self.labelCount.text!)!
                                cart.updated = true
                                self.cart[oldCartIndex] = cart
                                
                            } else {
                                self.cart.append(newCart)
                            }
                            self.flagUpdated = true
                            let alertController = UIAlertController(title: "Thông báo", message: "Thêm sản phẩm thành công", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                let controller = self.navigationController!.viewControllers[1] as! MenuOrderViewController
                                controller.cart = self.cart
                                controller.countItemCart = self.countItemCart
                                self.navigationController!.popToViewController(controller, animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                let newCart = Cart(id: menu.productId, name: txtProductName.text!, quantity: Int(labelCount.text!)!, price: menu.price, updated: false)
                if let oldCartIndex = self.cart.firstIndex(where: { $0.name == newCart.name }) {
                    var cart = self.cart[oldCartIndex]
                    cart.quantity += Int(labelCount.text!)!
                    countItemCart += Int(labelCount.text!)!
                    self.cart[oldCartIndex] = cart
                } else {
                    self.cart.append(newCart)
                    countItemCart += Int(labelCount.text!)!
                }
                let alertController = UIAlertController(title: "Thông báo", message: "Thêm sản phẩm thành công", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let controller = self.navigationController!.viewControllers[1] as! MenuOrderViewController
                    controller.cart = self.cart
                    controller.countItemCart = self.countItemCart
                    self.navigationController!.popToViewController(controller, animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtProductName.text = menu.name
        createPickerViewType()
        createToolbarPickerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func createPickerViewType() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        txtType.inputView = typePicker
    }
    
    private func createToolbarPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(MenuDetailViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtType.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension MenuDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtType.isEditing) {
            item = type.count
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtType.isEditing) {
            item = type[row]
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(txtType.isEditing) {
            selectItem = type[row]
            txtType.text = selectItem
        }
    }
    
}

