//
//  UIViewController.swift
//  ShareAds
//
//  Created by NXA on 3/20/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
var VW_overlay: UIView = UIView()

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func initIndicator() {
        DispatchQueue.main.async {
            VW_overlay = UIView(frame: UIScreen.main.bounds)
            VW_overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
            
            activityIndicatorView = UIActivityIndicatorView(style: .gray)
            activityIndicatorView.frame = CGRect(x: 0, y: 0, width: activityIndicatorView.bounds.size.width, height: activityIndicatorView.bounds.size.height)
            
            activityIndicatorView.center = VW_overlay.center
            VW_overlay.addSubview(activityIndicatorView)
            VW_overlay.center = self.view.center
            self.view.addSubview(VW_overlay)
            
            activityIndicatorView.startAnimating()
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            activityIndicatorView.stopAnimating()
            VW_overlay.isHidden = true
        }
    }
}

