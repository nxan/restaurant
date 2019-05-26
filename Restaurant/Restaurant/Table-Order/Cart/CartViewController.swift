//
//  CartViewController.swift
//  Restaurant
//
//  Created by NXA on 5/5/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: UIViewController {
    
    let URL_ORDER = "http://localhost:8888/order/"
    let URL_ORDER_DETAIL = "http://localhost:8888/orderdetail/"
    let URL_DESK = "http://localhost:8888/desks/"
    
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(rgb: 0xff5a66)
    
    @IBOutlet var buttonplaceOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelDesk: UILabel!
    
    
    let cellId = "CartCell"
    var cart: [Cart] = []
    var cartUpdated: [Cart] = []
    let headers = ["Thành phần"]
    var countItemCart: Int = 0
    var desk: Desk!
    var time = Date()
    var flagUpdated = false
    
    @IBAction func buttonBack(_ sender: Any) {
        let controller = self.navigationController!.viewControllers[1] as! MenuOrderViewController
        controller.cart = self.cart
        controller.countItemCart = self.countItemCart
        self.navigationController!.popToViewController(controller, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customButtonPlaceOrder()
        labelDesk.text = desk.deskName
        getFoodByDesk(deskId: desk.deskId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print(cart)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func customButtonPlaceOrder() {
        buttonplaceOrder.setTitle("Đặt món", for: .normal)
        buttonplaceOrder.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        buttonplaceOrder.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
    }
    
    @objc func placeOrder() {
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        let parameters = [
            "INHOADON": false,
            "MaBan": desk.deskId,
            "GIOVAO": "\(time.hour):\(minute)",
            "GIORA": "",
            "KETTHUC": false,
            "TRANGTHAI": "Sử dụng",
            "MaNhanVienBan": "Nguyễn Xuân An",
            "HostName": "NXAN",
            "MaGiam": 0,
            "Huy": 0,
            "TongMon": countItemCart
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_ORDER)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                self.checkDeskEnable(deskId: self.desk.deskId)
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func checkDeskEnable(deskId: Int) {
        var orderId = ""
        Alamofire.request(URL_ORDER + "checkDesk/\(deskId)", method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            orderId = item["SOHOADON"] as! String
                            self.saveFood(orderId: orderId)
                            self.updateDeskHasPeople(deskId: deskId)
                        }
                    }
                }
        }
    }
    
    func saveFood(orderId: String) {
        for item in cart {
            let parameters = [
                "SOHOADON": orderId,
                "MaMon": item.id,
                "SoLuongTra": 0,
                "SoLuong": item.quantity,
                "TenMon": item.name,
                "DonGiaBan": item.price
                ] as Dictionary<String, Any>
            print(parameters)
            var request = URLRequest(url: URL(string: URL_ORDER_DETAIL)!)
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
    }
    
    func updateDeskHasPeople(deskId: Int) {
        let parameters = [
            "TongMon": countItemCart
        ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_DESK + "updateDeskHasPeople/" + "\(deskId)")!)
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
    
    func getFoodByDesk(deskId: Int) {
        if(desk.enable && !flagUpdated) {
            cart.removeAll()
            UserDefaults.standard.set(false, forKey: "flagAddCart")
            Alamofire.request(self.URL_ORDER_DETAIL + "getOne/\(deskId)", method: .get, encoding: JSONEncoding.default).responseJSON
                { (response) in
                    if let responseValue = response.result.value as! [String: Any]? {
                        if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                                for item in responseOrder {
                                    self.cart.append(Cart(id: item["MaMon"] as! Int, name: item["TenMon"] as! String, quantity: item["SoLuong"] as! Int, price: item["DonGiaBan"] as! Double, updated: false))
                                    self.tableView.reloadData()
                                }
                        }
                    }
            }
        }
    }
    
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) { return cart.count }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CartCell", owner: self, options: nil)?.first as! CartCell
        if(headers[indexPath.section] == headers[0]) { cell.configureWith(cart[indexPath.row]) }
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
                countItemCart -= cart[indexPath.row].quantity
                cart.remove(at: indexPath.row)
                let tempIndexPath = IndexPath(row: indexPath.row, section: 0)
                tableView.deleteRows(at: [tempIndexPath], with: .fade)
            }
            tableView.reloadData()
        }
    }
        
}
