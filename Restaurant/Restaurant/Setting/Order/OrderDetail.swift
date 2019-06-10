//
//  OrderDetail.swift
//  Restaurant
//
//  Created by NXA on 6/10/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct OrderDetail {
    let orderDetailId: Int
    let orderId: String
    let foodName: String
    let quantity: Int
    let unit: Double
    
    init(orderDetailId: Int, orderId: String, foodName: String, quantity: Int, unit: Double) {
        self.orderDetailId = orderDetailId
        self.orderId = orderId
        self.foodName = foodName
        self.quantity = quantity
        self.unit = unit
    }
}

