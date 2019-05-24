//
//  MenuCell.swift
//  Restaurant
//
//  Created by NXA on 5/4/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMoney: UILabel!
    @IBOutlet weak var labelStock: UILabel!
    
    var btnAdd : (() -> Void)? = nil
    
    @IBAction func buttonAddOrder(_ sender: UIButton) {
        if let btnAction = self.btnAdd
        {
            btnAction()
        }
    }    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureWith(_ menu: Menu) {
        labelName.text = menu.name
        if(menu.stock > 0) {
            labelStock.text = "Còn hàng"
            labelStock.textColor = UIColor.vegaGreen
        } else {
            labelStock.text = "Hết hàng"
            labelStock.textColor = UIColor(rgb: 0xF93C64)
        }
        labelMoney.text = addCommaNumber(string: forTrailingZero(temp: menu.price))
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
