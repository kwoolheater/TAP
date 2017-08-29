//
//  DetailViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/16/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    // declare variables
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var drink: DownloadedDrink?
    var coreDataDrink: Drink?
    var isFavorite: Bool?
    var price: Double?
    
    // initalize outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = drink?.name
        
        if drink?.price750mL != nil {
            price = (drink?.price750mL)!
        } else if drink?.otherPrice != nil {
            price = (drink?.otherPrice)!
        } else if drink?.price175L != nil {
            price = (drink?.price175L)!
        }
        
        priceLabel.text = "Price: $\(price ?? 0)"
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        
    }
    
    @IBAction func favorite(_ sender: Any) {
        if isFavorite == nil || isFavorite == false {
            DispatchQueue.main.async {
                self.saveToCoreData()
            }
            isFavorite = true
            favoritesButton.tintColor = .red
        } else {
            DispatchQueue.main.async {
                self.deleteFromCoreData(savedDrink: self.coreDataDrink!)
            }
            isFavorite = false
            favoritesButton.tintColor = .black
        }
    }
    
    func saveToCoreData() {
        let fav = Drink(name: (drink?.name)!, price: (price)!, context: stack.context)
        coreDataDrink = fav
        do {
            try stack.context.save()
        } catch {
            print("Error saving favorite.")
        }
    }
    
    func deleteFromCoreData(savedDrink: Drink) {
        stack.context.delete(savedDrink)
        do {
            try stack.context.save()
        } catch {
            print("Error saving favorite.")
        }
    }
}
