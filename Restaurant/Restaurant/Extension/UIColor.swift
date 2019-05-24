//
//  UIColor.swift
//  Restaurant
//
//  Created by NXA on 5/2/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

extension UIColor {
    static var vegaRed: UIColor {
        return UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0)
    }
    
    static var vegaGreen: UIColor {
        return UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
    }
    
    static var vegaGray: UIColor {
        return UIColor(red:0.51, green:0.51, blue:0.55, alpha:1.0)
    }
    
    static var vegaBlack: UIColor {
        return UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
