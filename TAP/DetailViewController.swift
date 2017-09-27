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

class DetailViewController: CoreDataViewController, UINavigationControllerDelegate {
    
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
    
    // initalize the core data stack
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the navigation controller delegate to self
        navigationController?.delegate = self
        
        // call the drink text function and the core data function
        setDrinkText()
        checkCoreData()
    }
    
    func setDrinkText() {
        if drink != nil {
            name.text = drink?.name
            
            if drink?.price750mL != nil {
                price = (drink?.price750mL)!
            } else if drink?.otherPrice != nil {
                price = (drink?.otherPrice)!
            } else if drink?.price175L != nil {
                price = (drink?.price175L)!
            }
            
            priceLabel.text = "Price: $\(price ?? 0)"
        } else {
            name.text = coreDataDrink?.name
            priceLabel.text = "Price: $\((coreDataDrink?.price)!)"
            isFavorite = true
            favoritesButton.tintColor = .red
        }
    }
    
    func checkCoreData() {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            SavedItems.sharedInstance().favoritesArray = try stack.context.fetch(fr) as! [Drink]
        } catch {
            fatalError("Could not fetch favorites.")
        }
        
        for drink in SavedItems.sharedInstance().favoritesArray {
            if drink.name == self.drink?.name {
                isFavorite = true
                favoritesButton.tintColor = .red
                self.coreDataDrink = drink
            }
        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        let alertController = UIAlertController(title: "Ordering Unavailable!", message: "Ordering will be available in your area soon.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.destructive, handler: nil))
        present(alertController, animated: true)
    }
    
    @IBAction func favorite(_ sender: Any) {
        if isFavorite == nil || isFavorite == false {
            if SavedItems.sharedInstance().userName != "No name" {
                DispatchQueue.main.async {
                    self.saveToCoreData()
                }
                isFavorite = true
                favoritesButton.tintColor = .red
            } else {
                let alertViewController = UIAlertController(title: "Login Error", message: "There was an error logging your account in. Please login again before adding favorites.", preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
                present(alertViewController, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.deleteFromCoreData(savedDrink: self.coreDataDrink!)
            }
            isFavorite = false
            favoritesButton.tintColor = .black
        }
    }
    
    func saveToCoreData() {
        let fav = Drink(userName: SavedItems.sharedInstance().userName!, name: (drink?.name)!, price: (price)!, context: stack.context)
        coreDataDrink = fav
        do {
            try stack.context.save()
        } catch {
            print("Error saving favorite.")
        }
        SavedItems.sharedInstance().favoritesArray.append(fav)
    }
    
    func deleteFromCoreData(savedDrink: Drink) {
        stack.context.delete(savedDrink)
        
        do {
            try stack.context.save()
        } catch {
            print("Error saving favorite.")
        }
        
        if let index = SavedItems.sharedInstance().favoritesArray.index(of: savedDrink) {
            SavedItems.sharedInstance().favoritesArray.remove(at: index)
        }
    }
}
