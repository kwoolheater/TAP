//
//  DrinkTableView.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/4/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import Firebase
import ReachabilitySwift

class DrinkTableViewController: UIViewController {
    
    // declare variables
    var sentDrink: DownloadedDrink?
    var type: String!
    var ref: DatabaseReference!
    var items = [DownloadedDrink]()
    fileprivate var _refHandle: DatabaseHandle!
    let reachability = Reachability()!
    
    // outlets :)
    @IBOutlet var drinkTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        configureDatabase()
        retrieveData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // MARK: config
    // configure database
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func retrieveData() {
        // start activity indicator
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        // gets all the data from Firebase and puts it into an items array
        _refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            // declare variables
            let postDic = snapshot.value as? [String:AnyObject]
            var liquorArray: [String:AnyObject]?
            var drinkName: String?
            var price1: Double?
            var price2: Double?
            var price3: Double?
            var price4: Double?
            var size: String?
            
            // parsed the data by alcohol type
            for (key, value) in postDic! {
                if key == self.type {
                    liquorArray = value as? [String : AnyObject]
                }
            }
            
            // parse Beer data
            if self.type == "Beer" {
                for (key, value) in liquorArray! {
                    drinkName = key
                    if let typeArray = value as? [String: AnyObject] {
                        for (key, value) in typeArray {
                            if key == "type" {
                                if let canAndBottleArray = value as? [String: AnyObject] {
                                    for (key, value) in canAndBottleArray {
                                        if key == "bottle" {
                                            if let bottlePricesArray = value as? [String: AnyObject] {
                                                for (key, value) in bottlePricesArray {
                                                    if key == "6" {
                                                        price4 = value as? Double
                                                        size = "6 pack"
                                                    }
                                                }
                                                
                                                // add beer data to items array and stop activity indicator
                                                self.items.append(DownloadedDrink.init(name: drinkName!, price175: price1, price1:price2, price750: price3, otherPrice: price4, otherSize: size))
                                                DispatchQueue.main.async {
                                                    self.activityIndicator.stopAnimating()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            // parse all other alcohol type data
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
                                // add to items array
                                self.items.append(DownloadedDrink.init(name: drinkName!, price175: price1, price1:price2, price750: price3, otherPrice: price4, otherSize: size))
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                        }
                    }
                }
            }
            
            // reload the table view on the main queue
            DispatchQueue.main.async {
                self.drinkTable.reloadData()
            }
        })
    }
    
    @objc func reachabilityChanged(note: Notification) {
        // function that finds out if there is a network connection
        
        // create a reachability object
        let reachability = note.object as! Reachability
        
        // if it isn't reachable present an alert controller
        if reachability.isReachable {
        } else {
            let alertController = UIAlertController(title: "Error", message: "Check your internet connection.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    deinit {
        // deinitalize all of the observers
        ref.child(type).removeObserver(withHandle: _refHandle)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
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
        // send the drink that was selected to the next view controller
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
