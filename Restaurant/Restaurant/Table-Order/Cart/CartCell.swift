//
//  CartCell.swift
//  Restaurant
//
//  Created by NXA on 5/5/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    

    override func awakeFromNib() {
        
    }

    func configureWith(_ cart: Cart) {
        if(cart.isNew || cart.updated) {
            labelProductName.textColor = UIColor(rgb: 0xF93C64)
        }
        labelProductName.text = "\(cart.name)"
        labelCount.text = "Số lượng: \(cart.quantity)"
        labelPrice.text = addCommaNumber(string: forTrailingZero(temp: cart.price))
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
