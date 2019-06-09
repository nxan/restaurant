//
//  FoodViewController.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit
import Alamofire

class FoodViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = Server.init().url
    lazy var URL_FOOD = url + "food"
    
    var food: [Food] = []
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
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ADDNEWFOOD") as! AddNewFoodViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func findAll() {
        food.removeAll()
        Alamofire.request(URL_FOOD, method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        for item in responseOrder {
                            self.food.append(Food(foodId: item["MaMon"] as! Int, foodName: item["TenMon"] as! String, groupId: item["IDNhom"] as! Int, groupName: item["TenNhom"] as! String, quantity: item["DonVi"] as! Int, unit: item["DonGiaBan"] as! Double))
                        }
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    func deleteFood(foodId: Int) {
        let parameters = [
            :] as Dictionary<String, Any>
        var request = URLRequest(url: URL(string: URL_FOOD + "/\(foodId)")!)
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
                self.alert(title: "Có lỗi xảy ra trong quá trình xóa", message: "Bạn không thể xóa món ăn đang được sử dụng")
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

extension FoodViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FoodTableViewCell", owner: self, options: nil)?.first as! FoodTableViewCell
        cell.configureWith(food[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteFood(foodId: food[indexPath.row].foodId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showUpdateView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AddNewFoodViewController,
            segue.identifier == "showUpdateView" {
            let row = (sender as! IndexPath).row
            viewController.food = food[row]
            viewController.isUpdate = isUpdate
        }
        
    }
    
}
