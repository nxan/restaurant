//
//  OrderDetailTableViewCell.swift
//  Restaurant
//
//  Created by NXA on 6/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var labelFoodName: UILabel!
    @IBOutlet var labelQuantity: UILabel!
    @IBOutlet var labelUnit: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ orderDetail: OrderDetail) {
        labelFoodName.text = "\(orderDetail.foodName)"
        labelQuantity.text = "Số lượng: \(orderDetail.quantity)"
        labelUnit.text = addCommaNumber(string: forTrailingZero(temp: orderDetail.unit))
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
