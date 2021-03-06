//
//  MenuContainerViewController.swift
//  Restaurant
//
//  Created by NXA on 5/7/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class MenuContainerViewController: UIViewController {
    
    
    var cart: [Cart] = []
    var countItemCart: Int = 0
    var desk: Desk!
    var menu: Menu!
    let time = Date()
    var flagUpdated = false
    
    @IBOutlet weak var labelDesk: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    

    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        labelTime.text = "\(time.hour):\(minute)"
        labelDesk.text = desk.deskName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MenuDetailViewController,
            segue.identifier == "showEmbedMenuDetail" {
            viewController.desk = desk
            viewController.menu = menu
            viewController.cart = cart
            viewController.countItemCart = countItemCart
            viewController.flagUpdated = flagUpdated
        }
    }
       
}
