//
//  Drink+CoreDataClass.swift
//  
//
//  Created by Kiyoshi Woolheater on 9/1/17.
//
//

import Foundation
import CoreData

@objc(Drink)
public class Drink: NSManagedObject {
    convenience init(userName: String, name: String, price: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Drink", in: context) {
            self.init(entity: ent, insertInto: context)
            self.name = name
            self.price = price
            self.userName = userName
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
