//
//  Place.swift
//  Restaurant
//
//  Created by NXA on 6/8/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Place  {
    let placeId: Int
    let placeName: String
    
    init(placeId: Int, placeName: String) {
        self.placeId = placeId
        self.placeName = placeName
    }
}
