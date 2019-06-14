//
//  LandingScreenViewController.swift
//  ShareAds
//
//  Created by NXA on 3/19/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class LandingScreenViewController: UIViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let subtitleColor = UIColor(hexString: "#464646")
    private let signUpButtonColor = UIColor(hexString: "#414665")
    private let signUpButtonBorderColor = UIColor(hexString: "#B0B3C6")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 25)
    private let subtitleFont = UIFont.boldSystemFont(ofSize: 18)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 24)

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.tintColor = tintColor
        
        titleLabel.font = titleFont
        titleLabel.text = "Chào mừng bạn đến với Restaurant"
        titleLabel.textColor = tintColor
        
        subtitleLabel.font = subtitleFont
        subtitleLabel.text = "Hãy bắt đầu với Restaurant để dễ dàng quản lý cửa hàng của bạn."
        subtitleLabel.textColor = subtitleColor
        
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: .white,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        signUpButton.setTitle("Đăng ký", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: signUpButtonColor,
                               font: buttonFont,
                               cornerRadius: 55/2,
                               borderColor: signUpButtonBorderColor,
                               backgroundColor: backgroundColor,
                               borderWidth: 1)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func didTapLoginButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LOGINSCREEN")
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapSignUpButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SIGNUPSCREEN")
        self.present(vc, animated: true, completion: nil)
    }

}
