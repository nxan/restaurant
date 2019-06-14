//
//  UICustomTextField.swift
//  ShareAds
//
//  Created by NXA on 3/20/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class UICustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
