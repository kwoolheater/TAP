//
//  Drink.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/8/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation

class Drink: NSObject {
    
    var name: String?
    var price175L: Double?
    var price1L: Double?
    var price750mL: Double?
    
    init(name: String, price175: Double?, price1: Double?, price750: Double?) {
        // init prices and name
        self.name = name
        self.price175L = price175
        self.price1L = price1
        self.price750mL = price750
        
    }
    
    
    
}
