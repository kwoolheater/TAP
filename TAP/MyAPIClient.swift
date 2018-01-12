//
//  MyAPIClient.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 1/11/18.
//  Copyright © 2018 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import Stripe
import Firebase

class MyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL
    
}
