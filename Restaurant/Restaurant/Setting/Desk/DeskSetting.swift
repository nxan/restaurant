//
//  DeskSetting.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct DeskSetting  {
    let deskId: Int
    let deskName: String
    let placeId: Int
    let place: String
    
    init(deskId: Int, deskName: String, placeId: Int, place: String) {
        self.deskId = deskId
        self.deskName = deskName
        self.placeId = placeId
        self.place = place
    }
}
