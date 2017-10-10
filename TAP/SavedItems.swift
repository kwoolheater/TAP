//
//  SavedItems.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/29/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
class SavedItems: NSObject {
    
    // initailized the drink array
    var favoritesArray = [Drink]()
    var userName: String?
    var isLoggedIn: Bool?
    
    // create a shared instance
    class func sharedInstance() -> SavedItems {
        struct Singleton {
            static var sharedInstance = SavedItems()
        }
        return Singleton.sharedInstance
    }
}
