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
import Stripe

class DetailViewController: CoreDataViewController, UINavigationControllerDelegate, STPPaymentContextDelegate {
    
    // add STPPaymentContext protocol 
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        <#code#>
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        <#code#>
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        <#code#>
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        <#code#>
    }
    
    
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
        // this function sets the text for the name of the drink and the price of the drink on this controller
        
        // if statement that differentiates between a drink that is stored in core data or not by checking if the if variable is nil or not
        if drink != nil {
            
            // set the text of the name label
            name.text = drink?.name
            
            // check to see what bottle size to populate
            if drink?.price750mL != nil {
                price = (drink?.price750mL)!
            } else if drink?.otherPrice != nil {
                price = (drink?.otherPrice)!
            } else if drink?.price175L != nil {
                price = (drink?.price175L)!
            }
            
            // set the price label
            priceLabel.text = "Price: $\(price ?? 0)"
        } else {
            // set the name label
            name.text = coreDataDrink?.name
            
            // set the price label
            priceLabel.text = "Price: $\((coreDataDrink?.price)!)"
            
            // set the favorites button to favorited
            isFavorite = true
            favoritesButton.tintColor = .red
        }
    }
    
    func checkCoreData() {
        // this function checks a current drink against core data too see if this drink is favorited or not (in the case that the drink isn't called from the favorites array
        
        // create a fetch request with sort descriptors
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // try the fetch and save it to the Saved Items array if it suceeds otherwise crash the app
        do {
            SavedItems.sharedInstance().favoritesArray = try stack.context.fetch(fr) as! [Drink]
        } catch {
            fatalError("Could not fetch favorites.")
        }
        
        // check to see if the drink pass from last view controller is in the favorites array
        for drink in SavedItems.sharedInstance().favoritesArray {
            // if it is then favorite the drink
            if drink.name == self.drink?.name {
                isFavorite = true
                favoritesButton.tintColor = .red
                self.coreDataDrink = drink
            }
        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        // currently the order function is disabled, present an alert saying ordering isn't available
        let alertController = UIAlertController(title: "Ordering Unavailable!", message: "Ordering will be available in your area soon.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.destructive, handler: nil))
        present(alertController, animated: true)
    }
    
    @IBAction func favorite(_ sender: Any) {
        // this action either favorites or unfavorites a drink and then places it in Core Data and the favorites table 
        
        // if statement checking whether a drink is favorited or not already
        if isFavorite == nil || isFavorite == false {
            // save to core data and add to favorites if there is a username
            if SavedItems.sharedInstance().userName != "No name" {
                DispatchQueue.main.async {
                    self.saveToCoreData()
                }
                isFavorite = true
                favoritesButton.tintColor = .red
            } else {
                // if there isn't a username present an alert saying there was an error logging in
                let alertViewController = UIAlertController(title: "Login Error", message: "There was an error logging your account in. Please login again before adding favorites.", preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
                present(alertViewController, animated: true, completion: nil)
            }
        } else {
            // if it is a favorite than unfavorite and delete from core data
            DispatchQueue.main.async {
                self.deleteFromCoreData(savedDrink: self.coreDataDrink!)
            }
            isFavorite = false
            favoritesButton.tintColor = .black
        }
    }
    
    func saveToCoreData() {
        // function that saves the drink information to core data
        
        // create a drink object and try saving it
        let fav = Drink(userName: SavedItems.sharedInstance().userName!, name: (drink?.name)!, price: (price)!, context: stack.context)
        coreDataDrink = fav
        do {
            try stack.context.save()
        } catch {
            print("Error saving favorite.")
        }
        
        // add drink to the favorites array
        SavedItems.sharedInstance().favoritesArray.append(fav)
    }
    
    func deleteFromCoreData(savedDrink: Drink) {
        // function that deletes drink information from core data
        
        // delete from core data and save context
        stack.context.delete(savedDrink)
        
        do {
            try stack.context.save()
        } catch {
            print("Error saving favorite.")
        }
        
        // remove from favorites array
        if let index = SavedItems.sharedInstance().favoritesArray.index(of: savedDrink) {
            SavedItems.sharedInstance().favoritesArray.remove(at: index)
        }
    }
}
