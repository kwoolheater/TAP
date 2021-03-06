//
//  Drink+CoreDataProperties.swift
//  
//
//  Created by Kiyoshi Woolheater on 9/1/17.
//
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var userName: String?

}
