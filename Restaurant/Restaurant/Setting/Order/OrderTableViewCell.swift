//
//  OrderTableViewCell.swift
//  Restaurant
//
//  Created by NXA on 6/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet var labelOrderId: UILabel!
    @IBOutlet var labelCreated: UILabel!
    @IBOutlet var labelDeskName: UILabel!
    @IBOutlet var labelStart: UILabel!
    @IBOutlet var labelEnd: UILabel!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var labelQuantityFood: UILabel!
    @IBOutlet weak var img: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ order: Order) {
        labelOrderId.text = "Số hóa đơn: (#\(order.orderId))"
        labelCreated.text = "Ngày tạo: \(order.created)"
        labelDeskName.text = "Bàn: \(order.deskName)"
        labelStart.text = "Giờ vào: \(order.start)"
        labelEnd.text = "Giờ ra: \(order.end)"
        labelQuantityFood.text = "Tổng món: \(order.quantityFood)"
        if(order.status) {
            labelStatus.text = "Trạng thái: Đã thanh toán"
            img.image = UIImage(named: "success")
        } else {
            labelStatus.text = "Trạng thái: Chưa thanh toán"
        }
    }
    
}
