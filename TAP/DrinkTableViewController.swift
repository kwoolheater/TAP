//
//  DrinkTableView.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/4/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import Firebase

class DrinkTableViewController: UIViewController {
    
    // declare variables
    var sentDrink: DownloadedDrink?
    var type: String!
    var ref: DatabaseReference!
    var items = [DownloadedDrink]()
    fileprivate var _refHandle: DatabaseHandle!
    
    // outlets :)
    @IBOutlet var drinkTable: UITableView!
    
    override func viewDidLoad() {
        configureDatabase()
        retrieveData()
    }
    
    // MARK: config
    // configure database
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func retrieveData() {
        
        _refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let postDic = snapshot.value as? [String:AnyObject]
            var liquorArray: [String:AnyObject]?
            var drinkName: String?
            var price1: Double?
            var price2: Double?
            var price3: Double?
            var price4: Double?
            var size: String?
            
            for (key, value) in postDic! {
                if key == self.type {
                    liquorArray = value as? [String : AnyObject]
                }
            }
            
            if self.type == "Beer" {
                for (key, value) in liquorArray! {
                    drinkName = key
                    if let typeArray = value as? [String: AnyObject] {
                        for (key, value) in typeArray {
                            if key == "type" {
                                if let canAndBottleArray = value as? [String: AnyObject] {
                                    print(canAndBottleArray)
                                    for (key, value) in canAndBottleArray {
                                        if key == "bottle" {
                                            if let bottlePricesArray = value as? [String: AnyObject] {
                                                for (key, value) in bottlePricesArray {
                                                    if key == "6" {
                                                        price4 = value as? Double
                                                        size = "6 pack"
                                                    }
                                                }
                                                
                                                self.items.append(DownloadedDrink.init(name: drinkName!, price175: price1, price1:price2, price750: price3, otherPrice: price4, otherSize: size))
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            /* } else if self.type == "Wine" {
                for (key, value) in liquorArray! {
                drinkName = key
                if let priceArray = value as? [String: AnyObject] {
                    for (_ , value) in priceArray {
                        if let individualPriceArray = value as? [String: AnyObject] {
                            for (key, value) in individualPriceArray {
                                if key == "750mL" {
                                    price3 = value as? Double
                                }
                            }
                            self.items.append(Drink.init(name: drinkName!, price175: price1, price1:price2, price750: price3, otherPrice: price4, otherSize: size))
                        }
                    }
                    }
                }*/
                
                
            } else {
                for (key, value) in liquorArray! {
                    drinkName = key
                    if let priceArray = value as? [String: AnyObject] {
                        for (_ , value) in priceArray {
                            if let individualPriceArray = value as? [String: AnyObject] {
                                for (key, value) in individualPriceArray {
                                    if key == "750mL" {
                                        price3 = value as? Double
                                    } else if key == "1L" {
                                        price2 = value as? Double
                                    } else if key == "1,75L" {
                                        price1 = value as? Double
                                    } else {
                                        price4 = value as? Double
                                        size = key as? String
                                    }
                                }
                                self.items.append(DownloadedDrink.init(name: drinkName!, price175: price1, price1:price2, price750: price3, otherPrice: price4, otherSize: size))
                                print(self.items)
                            }
                        }
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                self.drinkTable.reloadData()
            }
        })
    }
    
    deinit {
        ref.child(type).removeObserver(withHandle: _refHandle)
    }
}

extension DrinkTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell: UITableViewCell = drinkTable.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        // unpack drink items
        let drink = items[indexPath.row]
        cell.textLabel?.text = drink.name
        let priceString: String
        if drink.price175L != nil && drink.price750mL != nil {
            priceString = "$\(drink.price750mL!) - $\(drink.price175L!)"
        } else if drink.price750mL != nil {
            priceString = "$\(drink.price750mL!)"
        } else if drink.otherPrice != nil {
            priceString = "$\(drink.otherPrice!)"
        } else {
            priceString = "price unavilable"
        }
        cell.detailTextLabel?.text = priceString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sentDrink = items[indexPath.row]
        performSegue(withIdentifier: "showDetailController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailController" {
            let segue = segue.destination as! DetailViewController
            segue.drink = sentDrink
        }
    }
    
}
