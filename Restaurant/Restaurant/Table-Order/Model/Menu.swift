//
//  Menu.swift
//  Restaurant
//
//  Created by NXA on 5/5/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Menu {
    let productId: Int
    let name: String
    let stock: Int
    let price: Double
    
    init(productId: Int, name: String, stock: Int, price: Double) {
        self.name = name
        self.stock = stock
        self.price = price
        self.productId = productId
    }
    
    func getProductName() -> String {
        return name
    }
}
