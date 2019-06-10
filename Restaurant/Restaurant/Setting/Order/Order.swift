//
//  Order.swift
//  Restaurant
//
//  Created by NXA on 6/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Order {
    let orderId: String
    let created: String
    let deskId: Int
    let deskName: String
    let start: String
    let end: String
    let status: Bool //ket thuc
    let quantityFood: Int
    
    init(orderId: String, created: String, deskId: Int, deskName: String, start: String, end: String, status: Bool, quantityFood: Int) {
        self.orderId = orderId
        self.created = created
        self.deskId = deskId
        self.deskName = deskName
        self.start = start
        self.end = end
        self.status = status
        self.quantityFood = quantityFood
    }
}
