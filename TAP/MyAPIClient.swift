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
    
    let ref = Database.database().reference()
    static let sharedClient = MyAPIClient()
    var uid: String? = nil
    
    func completeCharge(_ result: STPPaymentResult, amount: Int, shippingAddress: STPAddress, completion: @escaping STPErrorBlock) {
        
        
        
        
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let email = SavedItems.sharedInstance().userName
        ref.child("stripe_customers").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for (id , user) in value! {
                let newUser = user as? NSDictionary
                let uid = id
                for (value, item) in newUser! {
                    if value as! String == "email" {
                        let newEmail = item as! String
                        if newEmail == email {
                            self.uid = uid as! String
                        }
                        let key = UUID().uuidString
                        
                        self.ref.child("stripe_customers/\(self.uid!)/ephemeral_keys").setValue([apiVersion: key])
                            
                            //.setValue(apiVersion, withCompletionBlock: {(error, databaseRef) in
                            //print(databaseRef)
                    }
                }
            }
        })
    }
}
