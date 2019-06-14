//
//  LoginScreenViewController.swift
//  ShareAds
//
//  Created by NXA on 3/20/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class LoginScreenViewController: UIViewController {
    
    let url = Server.init().url
    lazy var URL_USER = url + "user"
    
    let defaultValues = UserDefaults.standard
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: UICustomTextField!
    @IBOutlet var contactPointTextField: UICustomTextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var backButton: UIButton!

    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#ff5a66")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    
    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactPointTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: contactPointTextField.frame.height))
        contactPointTextField.leftViewMode = .always
        
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
        
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.font = titleFont
        titleLabel.text = "Đăng nhập"
        titleLabel.textColor = tintColor
        
        contactPointTextField.configure(color: textFieldColor,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "Tên tài khoản"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true
        
        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 55/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        passwordTextField.placeholder = "Mật khẩu"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true
        
        
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func didTapBackButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LANDINGSCREEN")
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapLoginButton() {
        login(email: contactPointTextField.text!, password: passwordTextField.text!)
    }
    
    @objc func didTapFacebookButton() {
    }
    
    func login(email: String, password: String) {
        let parameters = [
            "email": email,
            "password": password
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_USER + "/auth")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200) {
                    DispatchQueue.main.async {
                        self.defaultValues.set(email, forKey: "key_email")
                        self.defaultValues.set(true, forKey: "key_login")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HOME")
                        self.present(vc, animated: true, completion: nil)
                    }
                } else if httpResponse.statusCode == 400 {
                    self.alert(title: "Đăng nhập thất bại", message: "Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.")
                }
            }
        })
        task.resume()
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }

    func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertSignUp(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LANDINGSCREEN")
                self.present(vc, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
