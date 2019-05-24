//
//  UIButton.swift
//  Restaurant
//
//  Created by NXA on 5/5/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

extension UIButton {
    
    func configure(color: UIColor = .blue,
                   font: UIFont = UIFont.boldSystemFont(ofSize: 12),
                   cornerRadius: CGFloat,
                   borderColor: UIColor? = nil,
                   backgroundColor: UIColor,
                   borderWidth: CGFloat? = nil) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        }
        self.layer.cornerRadius = cornerRadius
    }
}
