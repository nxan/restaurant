//
//  SignUpScreenViewController.swift
//  ShareAds
//
//  Created by NXA on 3/20/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class SignUpScreenViewController: UIViewController {
    
    let url = Server.init().url
    lazy var URL_USER = url + "user"

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var passwordTextField: UICustomTextField!
    @IBOutlet var retypePasswordTextField: UICustomTextField!
    @IBOutlet var emailTextField: UICustomTextField!
    @IBOutlet var fullnameTextField: UICustomTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let backgroundColor: UIColor = .white
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(hexString: "#282E4F")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        setPaddingTextField(textfield: passwordTextField)
        setPaddingTextField(textfield: retypePasswordTextField)
        setPaddingTextField(textfield: emailTextField)
        setPaddingTextField(textfield: fullnameTextField)
        
        titleLabel.font = titleFont
        titleLabel.text = "Đăng ký"
        titleLabel.textColor = tintColor
        
        emailTextField.configure(color: textFieldColor,
                                 font: textFieldFont,
                                 cornerRadius: 40/2,
                                 borderColor: textFieldBorderColor,
                                 backgroundColor: backgroundColor,
                                 borderWidth: 1.0)
        emailTextField.placeholder = "E-mail"
        emailTextField.clipsToBounds = true

        
        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        passwordTextField.placeholder = "Mật khẩu"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true
        
        retypePasswordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        retypePasswordTextField.placeholder = "Xác nhận mật khẩu"
        retypePasswordTextField.isSecureTextEntry = true
        retypePasswordTextField.clipsToBounds = true
        
        fullnameTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        fullnameTextField.placeholder = "Tên đầy đủ"
        fullnameTextField.clipsToBounds = true
        
        signUpButton.setTitle("Tạo tài khoản", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: UIColor(hexString: "#ff5a66"))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setPaddingTextField(textfield: UICustomTextField) {
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.leftViewMode = .always
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
    
    @objc func didTapSignUpButton() {
        if(emailTextField.text == "" || passwordTextField.text == "" || retypePasswordTextField.text == "" || fullnameTextField.text == "") {
            alert(title: "Vui lòng nhập đầy đủ thông tin", message: "")
        } else if(passwordTextField.text != retypePasswordTextField.text) {
            alert(title: "Xác nhận mật khẩu không trùng khớp", message: "")
        } else if(!isValidEmail(testStr: emailTextField.text!)) {
            alert(title: "Bạn đã nhập sai email", message: "")
        } else {
            findEmail(email: emailTextField.text!, password: passwordTextField.text!, name: fullnameTextField.text!)
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        let parameters = [
            "email": email,
            "password": password,
            "name": name
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_USER)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if(httpResponse.statusCode == 201) {
                    self.alertSignUp(title: "Đăng ký thành công", message: "Bạn đã đăng ký tài khoản thành công. Chúc bạn có một trải nghiệm tốt.")
                }
            }
        })
        task.resume()
    }
    
    func findEmail(email: String, password: String, name: String) {
        Alamofire.request(URL_USER + "/" + email, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if(response.response!.statusCode == 200) {
                    self.signUp(email: email, password: password, name: name)
                } else if(response.response!.statusCode == 400) {
                    self.alert(title: "Tài khoản đã tồn tại", message: "Vui lòng nhập email khác.")
                }
        }
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
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}

