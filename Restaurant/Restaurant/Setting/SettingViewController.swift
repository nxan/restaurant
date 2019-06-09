//
//  SettingViewController.swift
//  Restaurant
//
//  Created by NXA on 6/8/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    var titleSetting = [["Tài khoản", "Khu vực", "Bàn", "Nhóm thực phẩm", "Thực đơn", "Hóa đơn"]]
    var subtitle = [["Thông tin tài khoản của khách hàng", "Quản lý khu vực nhà hàng", "Quản lý bàn trong nhà hàng", "Quản lý nhóm thực phẩm", "Quản lý món ăn trong thực đơn", "Quản lý hóa đơn bán hàng"]]
    var image = ["account", "place", "table", "groupfood", "food", "order"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleSetting.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleSetting[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SettingTableViewCell", owner: self, options: nil)?.first as! SettingTableViewCell
        cell.titleLabel.text = titleSetting[indexPath.section][indexPath.row]
        cell.subTitleLabel.text = subtitle[indexPath.section][indexPath.row]
        cell.imageView?.image = UIImage(named: image[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            switch indexPath.row {
            case 0:
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PROFILE")
//                self.navigationController?.pushViewController(nextViewController, animated:true)
                break
            case 1:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PLACE") as! PlaceViewController
                self.navigationController?.pushViewController(nextViewController, animated:true)
                break
                
            case 2:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DESKSETTING") as! DeskSettingViewController
                self.navigationController?.pushViewController(nextViewController, animated:true)
                
            case 3:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GROUPFOOD") as! GroupFoodViewController
                self.navigationController?.pushViewController(nextViewController, animated:true)
                break
            
            default:
                break
            }
        }
    }
}
