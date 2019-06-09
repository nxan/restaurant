//
//  GroupFoodViewController.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class GroupFoodViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = Server.init().url
    lazy var URL_GROUP_FOOD = url + "groupfood"
    var groupFoodTextField: UITextField!
    
    var groupFood: [GroupFood] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonAdd = UIBarButtonItem(title: "Thêm", style: .plain, target: self, action: #selector(GroupFoodViewController.clickAdd))
        self.navigationItem.rightBarButtonItem = buttonAdd
        findAll()
    }
        
    @objc func clickAdd(){
        let alertController = UIAlertController(title: "Nhập nhóm thực phẩm", message: "Vui lòng nhập nhóm thực phẩm bạn muốn thêm", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: feeTextField)
        let okAction = UIAlertAction(title: "Xác nhận", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func feeTextField(textField: UITextField!) {
        groupFoodTextField = textField
        groupFoodTextField.placeholder = "Ví dụ: Cà phê, Nước ngọt..."
        groupFoodTextField.autocapitalizationType = .sentences
    }
    
    func okHandler(alert: UIAlertAction) {
        createGroupFood(groupFoodName: groupFoodTextField.text!)
    }
    
    func findAll() {
        groupFood.removeAll()
        Alamofire.request(URL_GROUP_FOOD, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.groupFood.append(GroupFood(groupFoodId: item["IDNhom"] as! Int, groupFoodName: item["TenNhom"] as! String))
                        }
                        self.tableView.reloadData()
                    }
                }
        }
    }
        
    func createGroupFood(groupFoodName: String) {
        let parameters = [
            "TenNhom": groupFoodName,
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_GROUP_FOOD)!)
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
    
    func deleteGroupFood(groupFoodId: Int) {
        let parameters = [
            :] as Dictionary<String, Any>
        var request = URLRequest(url: URL(string: URL_GROUP_FOOD + "/\(groupFoodId)")!)
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
                self.alert(title: "Có lỗi xảy ra trong quá trình xóa", message: "Bạn không thể xóa nhóm thực phẩm đang được sử dụng")
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

extension GroupFoodViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("GroupFoodTableViewCell", owner: self, options: nil)?.first as! GroupFoodTableViewCell
        cell.configureWith(groupFood[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteGroupFood(groupFoodId: groupFood[indexPath.row].groupFoodId)
        }
    }
    
}
