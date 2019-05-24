//
//  CheckOutViewController.swift
//  Restaurant
//
//  Created by NXA on 5/13/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController {

    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(rgb: 0xff5a66)
    
    @IBOutlet var buttonplaceOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let cellId = "CartCell"
    fileprivate var cart: [Cart] = []
    fileprivate let headers = ["Thành phần", "Thanh toán"]
    var feeTextField: UITextField!
    var fee = 0
    
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
            fee = Int(feeTextField.text!)!
        }
        print(fee)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButtonPlaceOrder()
        //cart = CartHelper.generateCart()
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
            cell.labelPrice.text = "80,000"
            cell.labelProductName.text = "Tổng cộng"
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
}
