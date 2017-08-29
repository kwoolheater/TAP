//
//  Drink+CoreDataClass.swift
//  
//
//  Created by Kiyoshi Woolheater on 8/28/17.
//
//

import Foundation
import CoreData

@objc(Drink)
public class Drink: NSManagedObject {
    
    convenience init(name: String, price: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Drink", in: context) {
            self.init(entity: ent, insertInto: context)
            self.name = name
            self.price = price
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
