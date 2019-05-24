//
//  Date.swift
//  Restaurant
//
//  Created by NXA on 5/2/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

extension Date {
    var hour: Int { return Calendar.autoupdatingCurrent.component(.hour, from: self) }
    var minute: Int { return Calendar.autoupdatingCurrent.component(.minute, from: self) }
    
    
}
