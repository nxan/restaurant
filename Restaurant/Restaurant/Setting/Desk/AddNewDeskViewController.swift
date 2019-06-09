//
//  AddNewDeskViewController.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class AddNewDeskViewController: UITableViewController {
    
    let url = Server.init().url
    lazy var URL_DESK = url + "desk"
    lazy var URL_PLACE = url + "place"
    var place: [Place] = []
    var selectItem: String?
    
    @IBOutlet weak var txtDeskName: UITextField!
    @IBOutlet weak var txtPlace: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findAllPlace()
        place.insert(Place(placeId: 0, placeName: ""), at: 0)
        createPickerViewType()
        createToolbarPickerView()
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        if(txtPlace.text != "" && txtDeskName.text != "") {
            var placeId = 0
            for item in place {
                if(item.placeName == txtPlace.text) {
                    placeId = item.placeId
                }
            }
            createDesk(deskName: txtDeskName.text!, placeId: placeId)
            alertAddNew(title: "Thông báo", message: "Thêm bàn thành công.")
        } else {
            alert(title: "Thông báo", message: "Vui lòng điền đầy đủ thông tin.")
        }
    }
    
    func createDesk(deskName: String, placeId: Int) {
        let parameters = [
            "TenBan": deskName,
            "Khu" : placeId
            ] as Dictionary<String, Any>
        print(parameters)
        var request = URLRequest(url: URL(string: URL_DESK)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func findAllPlace() {
        Alamofire.request(URL_PLACE, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.place.append(Place(placeId: item["MaKhu"] as! Int, placeName: item["TenKhu"] as! String))
                        }
                    }
                }
        }
    }
    
    private func createPickerViewType() {
        let typePicker = UIPickerView()
        typePicker.delegate = self
        txtPlace.inputView = typePicker
    }
    
    private func createToolbarPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(MenuDetailViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        txtPlace.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertAddNew(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Xác nhận", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let controller = self.navigationController!.viewControllers[1] as! DeskSettingViewController
                self.navigationController!.popToViewController(controller, animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension AddNewDeskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var item = 0
        if(txtPlace.isEditing) {
            item = place.count
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var item = ""
        if(txtPlace.isEditing) {
            item = place[row].placeName
        }
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(txtPlace.isEditing) {
            selectItem = place[row].placeName
            txtPlace.text = selectItem
        }
    }
    
}
