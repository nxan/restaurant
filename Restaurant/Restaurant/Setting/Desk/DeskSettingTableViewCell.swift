//
//  DeskSettingTableViewCell.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class DeskSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelDeskName: UILabel!
    @IBOutlet weak var labelPlaceName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ desk: DeskSetting) {
        labelDeskName.text = "\(desk.deskName)"
        labelPlaceName.text = "Khu: \(desk.place)"
    }
    
}
