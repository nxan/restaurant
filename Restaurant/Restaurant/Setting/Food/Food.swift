//
//  Food.swift
//  Restaurant
//
//  Created by NXA on 6/9/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Food {
    let foodId: Int
    let foodName: String
    let groupId: Int
    let groupName: String
    let quantity: Int
    let unit: Double
    
    init(foodId: Int, foodName: String, groupId: Int, groupName: String, quantity: Int, unit: Double) {
        self.foodId = foodId
        self.foodName = foodName
        self.groupId = groupId
        self.groupName = groupName
        self.quantity = quantity
        self.unit = unit
    }
}
