//
//  GroupFoodTableViewCell.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class GroupFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelGroupFoodId: UILabel!
    @IBOutlet weak var labelGroupFoodName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ group: GroupFood) {
        labelGroupFoodId.text = "Mã nhóm: #\(group.groupFoodId)"
        labelGroupFoodName.text = "\(group.groupFoodName)"
    }
    
}
