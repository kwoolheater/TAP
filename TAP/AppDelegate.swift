//
//  AppDelegate.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 7/28/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // integrate the Core Data stack
    let stack = CoreDataStack(modelName: "Model")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // configure Firebase
        FirebaseApp.configure()
        
        // configure Stripe with publishable key
        Stripe.setDefaultPublishableKey("pk_test_zXwdlOOuj7gAsRYuZux4NsaU")
        
        return true
    }
}

