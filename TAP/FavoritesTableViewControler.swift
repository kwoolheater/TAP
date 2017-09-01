//
//  FavoritesTableViewControler.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/24/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

class FavoritesTableViewController: CoreDataViewController {
    
    //declare variables
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var sentDrink: Drink?
    var reloadData: Bool?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateArray()
        tableView.reloadData()
    }
    
    func populateArray() {
        // insert if username
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        fr.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true)]
        
        do {
            SavedItems.sharedInstance().favoritesArray = try stack.context.fetch(fr) as! [Drink]
            
        } catch {
            fatalError("Could not fetch favorites.")
        }
        
        remove()
    }
    
    func remove() {
        for items in SavedItems.sharedInstance().favoritesArray {
            if items.userName != SavedItems.sharedInstance().userName {
                if let index = SavedItems.sharedInstance().favoritesArray.index(of: items) {
                    SavedItems.sharedInstance().favoritesArray.remove(at: index)
                }
            }
        }
    }
    
}

extension FavoritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedItems.sharedInstance().favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        
        cell.textLabel?.text = SavedItems.sharedInstance().favoritesArray[indexPath.row].name
        cell.detailTextLabel?.text = "$\((SavedItems.sharedInstance().favoritesArray[indexPath.row].price))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sentDrink = SavedItems.sharedInstance().favoritesArray[indexPath.row]
        performSegue(withIdentifier: "favoritesSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            let segue = segue.destination as! DetailViewController
            segue.coreDataDrink = sentDrink
        }
    }
}
