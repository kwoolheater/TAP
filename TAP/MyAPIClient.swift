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
import Alamofire

class MyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    let ref = Database.database().reference()
    static let sharedClient = MyAPIClient()
    var uid: String? = nil
    
    func completeCharge(_ result: STPPaymentResult, amount: Int, shippingAddress: STPAddress, completion: @escaping STPErrorBlock) {
        
        
        
        
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        ref.child("stripe_customers/\(self.uid)/request_key").observe(.childAdded, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value)
            self.ref.child("stripe_customers/\(self.uid!)/ephemeral_key").setValue("you did it")
        })
        
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
                        
                        self.ref.child("stripe_customers/\(self.uid!)/request_key").setValue([apiVersion: key])
                    }
                }
            }
        })
        
        
        
        /*
        let url = "https://tap-application.firebaseio.com/stripe_customers/0HSIcTBOiucwVzwhaToPoYiEGJ83/key.json" as String
        
        let custID = "cus_C88V5bhXU2bMN2"
        
        var requestData : [String : String]? = [String : String]()
        requestData?.updateValue(apiVersion, forKey: "api_version")
        requestData?.updateValue(custID, forKey: "customerId")
        
        
        Alamofire.request(url!, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print(responseJSON)
                switch responseJSON.result {
                case .success(let json):
                    print(json)
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }*/
    }
    
    
    
}
