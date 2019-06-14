//
//  AddNewFoodViewController.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class AddNewFoodViewController: UITableViewController {
    
    let url = Server.init().url
    lazy var URL_FOOD = url + "food"
    lazy var URL_GROUP = url + "groupfood"
    var group: [GroupFood] = []
    var selectItem: String?
    var food: Food!
    var isUpdate = false
    
    @IBOutlet weak var txtFoodName: UITextField!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var labelButtonAdd: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        findAllGroup()
        group.insert(GroupFood(groupFoodId: 0, groupFoodName: ""), at: 0)
        createPickerViewType()
        createToolbarPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(isUpdate) {
            txtFoodName.text = food.foodName
            txtGroupName.text = food.groupName
            txtQuantity.text = "\(food.quantity)"
            txtUnit.text = addCommaNumber(string: String(food.unit))
            labelButtonAdd.setTitle("Cập nhật", for: .normal)
        }
    }
    
    @IBAction func btnAddNew(_ sender: Any) {
        if(txtGroupName.text != "" && txtFoodName.text != "" && txtUnit.text != "") {
            var groupId = 0
            for item in group {
                if(item.groupFoodName == txtGroupName.text) {
                    groupId = item.groupFoodId
                }
            }
            if(isUpdate) {
                let unit: String = removeCommaNumber(string: txtUnit.text!)!
                updateFood(foodId: food.foodId ,foodName: txtFoodName.text!, groupId: groupId, quantity: Int(txtQuantity.text!)!, unit: Double(unit)!)
                alertAddNew(title: "Thông báo", message: "Cập nhật món ăn thành công.")
            } else {
                createFood(foodName: txtFoodName.text!, groupId: groupId, quantity: Int(txtQuantity.text!)!, unit: Double(txtUnit.text!)!)
                alertAddNew(title: "Thông báo", message: "Thêm món ăn thành công.")
            }
        } else {
            alert(title: "Thông báo", message: "Vui lòng điền đầy đủ thông tin.")
        }
    }
    
    @IBAction func txtUnitEditChanged(_ sender: Any) {
        txtUnit.text = removeCommaNumber(string: txtUnit.text!)
    }
    
    
    func createFood(foodName: String, groupId: Int, quantity: Int, unit: Double) {
        let parameters = [
            "TenMon": foodName,
            "IDNhom" : groupId,
            "DonVi" : quantity,
            "DonGiaBan" : unit,
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_FOOD)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func updateFood(foodId: Int, foodName: String, groupId: Int, quantity: Int, unit: Double) {
        let parameters = [
            "MaMon": foodId,
            "TenMon": foodName,
            "IDNhom" : groupId,
            "DonVi" : quantity,
            "DonGiaBan" : unit,
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_FOOD)!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func findAllGroup() {
        Alamofire.request(URL_GROUP, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.group.append(GroupFood(groupFoodId: item["IDNhom"] as! Int, groupFoodName: item["TenNhom"] as! String))
                        }
                    }
                }
        }
    }
    
    private func createPickerViewType() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        txtGroupName.inputView = typePicker
    }
    
    private func createToolbarPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(MenuDetailViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtGroupName.inputAccessoryView = toolbar
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertAddNew(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let controller = self.navigationController!.viewControllers[1] as! FoodViewController
                self.navigationController!.popToViewController(controller, animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addCommaNumber(string: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSize = 3
        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(string)!))
        return formattedNumber
    }
    
    func removeCommaNumber(string: String) -> String? {
        return string.replacingOccurrences(of: ",", with: "")
    }
    
}

extension AddNewFoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtGroupName.isEditing) {
            item = group.count
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtGroupName.isEditing) {
            item = group[row].groupFoodName
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(txtGroupName.isEditing) {
            selectItem = group[row].groupFoodName
            txtGroupName.text = selectItem
        }
    }
    
}
