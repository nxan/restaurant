//
//  OrderViewController.swift
//  Restaurant
//
//  Created by NXA on 6/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = Server.init().url
    lazy var URL_ORDER = url + "order"
    
    var order: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        findAll()
    }
   
    func findAll() {
        Alamofire.request(URL_ORDER, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            var dateString = ""
                            let dateFromJSON = item["NGAYHOADON"] as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            if let date = dateFormatter.date(from: dateFromJSON) {
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                dateString = dateFormatter.string(from: date)
                            }
                            
                            self.order.append(Order(orderId: item["SOHOADON"] as! String, created: dateString, deskId: item["MaBan"] as! Int, deskName: item["TenBan"] as! String, start: item["GIOVAO"] as! String, end: item["GIORA"] as! String, status: item["KETTHUC"] as! Bool, quantityFood: item["TongMon"] as! Int))
                        }
                        self.tableView.reloadData()
                    }
                }
        }
    }

}


extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("OrderTableViewCell", owner: self, options: nil)?.first as! OrderTableViewCell
        cell.configureWith(order[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? OrderDetailViewController,
            segue.identifier == "showDetail" {
            let row = (sender as! IndexPath).row
            viewController.order = order[row]
        }
        
    }
}
