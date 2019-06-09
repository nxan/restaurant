//
//  PlaceTableViewCell.swift
//  Restaurant
//
//  Created by NXA on 6/8/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelPlaceId: UILabel!
    @IBOutlet weak var labelPlaceName: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ place: Place) {
        labelPlaceId.text = "Mã khu: #\(place.placeId)"
        labelPlaceName.text = "\(place.placeName)"
    }
    
}
