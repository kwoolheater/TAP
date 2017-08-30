//
//  SavedItems.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/29/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
class SavedItems: NSObject {
    
    var favoritesArray = [Drink]()
    
    class func sharedInstance() -> SavedItems {
        struct Singleton {
            static var sharedInstance = SavedItems()
        }
        return Singleton.sharedInstance
    }
}
