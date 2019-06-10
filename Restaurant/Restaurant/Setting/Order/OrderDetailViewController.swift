//
//  OrderDetailViewController.swift
//  Restaurant
//
//  Created by NXA on 6/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire


class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = Server.init().url
    lazy var URL_ORDERDETAIL = url + "orderdetail"
    fileprivate let headers = ["Thành phần", "Thanh toán"]
    var total = 0.0
    
    var order: Order?
    var orderDetail: [OrderDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        findAll()
    }
    
    func findAll() {
        Alamofire.request(URL_ORDERDETAIL + "/findByOrderId/" + order!.orderId, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.orderDetail.append(OrderDetail(orderDetailId: item["IDBanChiTiet"] as! Int, orderId: item["SOHOADON"] as! String, foodName: item["TenMon"] as! String, quantity: item["SoLuong"] as! Int, unit: item["DonGiaBan"] as! Double))
                        }
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
}

extension OrderDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) { return orderDetail.count }
        else { return 1 }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("OrderDetailTableViewCell", owner: self, options: nil)?.first as! OrderDetailTableViewCell
        if(headers[indexPath.section] == headers[0]) { cell.configureWith(orderDetail[indexPath.row]) }
        else if (headers[indexPath.section] == headers[1]) {
            total = 0
            for item in orderDetail {
                total += item.unit * Double(item.quantity)
            }
            cell.labelFoodName.text = "Tổng cộng"
            cell.labelUnit.text = addCommaNumber(string: forTrailingZero(temp: total))
            cell.labelUnit.textColor = UIColor(rgb: 0xF93C64)
            cell.labelQuantity.text = "Tổng món: \(order!.quantityFood)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
    
}
