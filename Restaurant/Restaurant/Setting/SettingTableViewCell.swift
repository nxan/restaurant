//
//  SettingTableViewCell.swift
//  Restaurant
//
//  Created by NXA on 6/8/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.frame = CGRect(x: 16, y: 19, width: 40, height: 40)
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
    }
    
}
