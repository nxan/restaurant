//
//  Desk.swift
//  Restaurant
//
//  Created by NXA on 5/2/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Desk  {
    let deskId: Int
    let deskName: String
    let enable: Bool
    let place: Int
    let count: Int

    init(deskId: Int, deskName: String, enable: Bool, place: Int, count: Int) {
        self.deskId = deskId
        self.deskName = deskName
        self.enable = enable
        self.place = place
        self.count = count
    }
}


