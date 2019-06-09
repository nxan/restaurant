//
//  DeskSettingViewController.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class DeskSettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = Server.init().url
    lazy var URL_DESK = url + "desk"
    
    var desk: [DeskSetting] = []
    var isUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonAdd = UIBarButtonItem(title: "Thêm", style: .plain, target: self, action: #selector(PlaceViewController.clickAdd))
        self.navigationItem.rightBarButtonItem = buttonAdd
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findAll()
    }
    
    @objc func clickAdd() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ADDNEWDESK") as! AddNewDeskViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func findAll() {
        desk.removeAll()
        Alamofire.request(URL_DESK, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.desk.append(DeskSetting(deskId: item["MaBan"] as! Int, deskName: item["TenBan"] as! String, placeId: item["Khu"] as! Int ,place: item["TenKhu"] as! String))
                        }
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    func deleteDesk(deskId: Int) {
        let parameters = [
            :] as Dictionary<String, Any>
        var request = URLRequest(url: URL(string: URL_DESK + "/\(deskId)")!)
        request.httpMethod = "DELETE"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                self.findAll()
            } catch {
                print("error")
                self.alert(title: "Có lỗi xảy ra trong quá trình xóa", message: "Bạn không thể xóa khu vực đang được sử dụng")
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
}

extension DeskSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DeskSettingTableViewCell", owner: self, options: nil)?.first as! DeskSettingTableViewCell
        cell.configureWith(desk[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteDesk(deskId: desk[indexPath.row].deskId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showUpdateView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AddNewDeskViewController,
            segue.identifier == "showUpdateView" {
            let row = (sender as! IndexPath).row
            viewController.desk = desk[row]
            viewController.isUpdate = isUpdate
        }
        
    }
    
}
