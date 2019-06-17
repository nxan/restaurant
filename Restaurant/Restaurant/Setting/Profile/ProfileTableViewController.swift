//
//  ProfileTableViewController.swift
//  Restaurant
//
//  Created by NXA on 6/15/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class ProfileTableViewController: UITableViewController {
    
    let url = Server.init().url
    lazy var URL_USER = url + "user/"
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetypePassword: UITextField!
    
    @IBAction func update(_ sender: Any) {
        if(txtName.text == "") {
            alert(title: "Vui lòng nhập tên đầy đủ", message: "")
        } else if(txtPassword.text != txtRetypePassword.text) {
            alert(title: "Xác nhận mật khẩu không trùng khớp", message: "")
        } else {
            update(email: txtEmail.text!, password: txtPassword.text!, name: txtName.text!)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LANDINGSCREEN")
        self.present(vc, animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "key_login")
        UserDefaults.standard.removeObject(forKey: "key_email")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       generateFullName(email: UserDefaults.standard.string(forKey: "key_email")!)
    }
        
    func generateFullName(email: String) {
        Alamofire.request(URL_USER + email, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.txtName.text = item["name"] as? String
                            self.txtEmail.text = item["email"] as? String
                        }
                    }
                }
        }
    }
    
    func update(email: String, password: String, name: String) {
        let parameters = [
            "email": email,
            "password": password,
            "name": name
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_USER)!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if(httpResponse.statusCode == 201) {
                    self.alertUpdate(title: "Cập nhật thành công", message: "")
                }
            }
        })
        task.resume()
    }
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertUpdate(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let controller = self.navigationController!.viewControllers[0] as! SettingViewController
                self.navigationController!.popToViewController(controller, animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
