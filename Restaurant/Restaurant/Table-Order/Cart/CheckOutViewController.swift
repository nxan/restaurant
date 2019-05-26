//
//  CheckOutViewController.swift
//  Restaurant
//
//  Created by NXA on 5/13/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class CheckOutViewController: UIViewController {
    
    let URL_ORDER_DETAIL = "http://localhost:8888/orderdetail/"
    let URL_ORDER = "http://localhost:8888/order/"
    let URL_DESK = "http://localhost:8888/desks/"

    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(rgb: 0xff5a66)
    
    @IBOutlet var buttonplaceOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "CartCell"
    var cart: [Cart] = []
    fileprivate let headers = ["Thành phần", "Thanh toán"]
    var feeTextField: UITextField!
    var fee = 0.0
    var total = 0.0
    var desk:Desk!
    var time = Date()
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFee(_ sender: Any) {
        let alertController = UIAlertController(title: "Nhập phí phụ thu", message: "Vui lòng nhập phí phụ thu hoặc các loại phí khác, tính theo %.", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: feeTextField)
        
        let okAction = UIAlertAction(title: "Xác nhận", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func feeTextField(textField: UITextField!) {
        feeTextField = textField
        feeTextField.placeholder = "Ví dụ: 5, 10, 15..."
        feeTextField.autocapitalizationType = .sentences
    }
    
    func okHandler(alert: UIAlertAction) {
        if(feeTextField.text == "") {
            fee = 0
        } else {
            fee = Double(feeTextField.text!)!
        }
        print(fee)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButtonPlaceOrder()
        
        getFoodByDesk(deskId: desk.deskId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func customButtonPlaceOrder() {
        buttonplaceOrder.setTitle("In hóa đơn", for: .normal)
        buttonplaceOrder.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        buttonplaceOrder.configure(color: backgroundColor,
                                   font: buttonFont,
                                   cornerRadius: 55/2,
                                   backgroundColor: tintColor)
    }
    
    @objc func placeOrder() {
        var orderId = ""
        Alamofire.request(URL_ORDER + "checkDesk/\(desk.deskId)", method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            orderId = item["SOHOADON"] as! String
                        }
                        self.pay(orderId: orderId)
                        self.updateDeskEmpty(deskId: self.desk.deskId)
                        self.alert(title: "Thông báo", message: "Đơn hàng đã được thanh toán")
                    }
                }
        }
    }
    
    func getFoodByDesk(deskId: Int) {
        Alamofire.request(self.URL_ORDER_DETAIL + "getOne/\(deskId)", method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.cart.append(Cart(id: item["MaMon"] as! Int, name: item["TenMon"] as! String, quantity: item["SoLuong"] as! Int, price: item["DonGiaBan"] as! Double, updated: false, isNew: false))
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
    func updateDeskEmpty(deskId: Int) {
        let parameters = [
            :] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_DESK + "updateDeskEmpty/" + "\(deskId)")!)
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
    
    func pay(orderId: String) {
        let time = Date()
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        let parameters = [
            "SOHOADON": orderId,
            "GIORA": "\(time.hour):\(minute)"
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_ORDER + "pay")!)
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
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let controller = self.navigationController!.viewControllers[0] as! DeskViewController
            self.navigationController!.popToViewController(controller, animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension CheckOutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) { return cart.count }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CartCell", owner: self, options: nil)?.first as! CartCell
        if(headers[indexPath.section] == headers[0]) { cell.configureWith(cart[indexPath.row]) }
        else if (headers[indexPath.section] == headers[1]) {
            total = 0
            for item in cart {
                total += item.price * Double(item.quantity)
            }
            if(fee > 0) {
                total = total + (total * fee / 100)
            }
            cell.labelProductName.text = "Tổng cộng"
            cell.labelPrice.text = addCommaNumber(string: forTrailingZero(temp: total))
            cell.labelCount.text = "Phụ thu: \(fee)%"
            cell.labelPrice.textColor = UIColor(rgb: 0xF93C64)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("CartTableSectionHeader", owner: self, options: nil)?.first as! CartTableSectionHeader
        header.labelHeader.text = headers[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if(indexPath.section == 0) {
                cart.remove(at: indexPath.row)
                let tempIndexPath = IndexPath(row: indexPath.row, section: 0)
                tableView.deleteRows(at: [tempIndexPath], with: .fade)
            }
            tableView.reloadData()
        }
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
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
