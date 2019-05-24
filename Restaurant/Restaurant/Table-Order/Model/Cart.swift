//
//  Cart.swift
//  Restaurant
//
//  Created by NXA on 5/5/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import Foundation

struct Cart {
    var id: Int
    var name: String
    var quantity: Int
    var price: Double
    
    init(id: Int, name: String, quantity: Int, price: Double) {
        self.name = name
        self.quantity = quantity
        self.price = price
        self.id = id
    }
    
    func getProductName() -> String {
        return name
    }
        
}
