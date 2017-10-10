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
    
    // declare variables
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var sentDrink: Drink?
    var reloadData: Bool?
    
    // declare outlets for the table view
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navigationButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        // this code was placed in the view will appear function instead of the viewdidload function because the table view needed to reload everytime the view appeared, including when a back button from the navigation bar on the detail view controller was pressed.
        super.viewWillAppear(true)
        populateArray()
        tableView.reloadData()
    }
    
    func populateArray() {
        // function that pulls from core data the favorites array for the specific user that is logged in unless there is no user currently logged in
        if SavedItems.sharedInstance().userName != "No name" {
            let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
            fr.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true)]
            
            do {
                SavedItems.sharedInstance().favoritesArray = try stack.context.fetch(fr) as! [Drink]
            } catch {
                fatalError("Could not fetch favorites.")
            }
        
            remove()
        } else {
            let alert = UIAlertController(title: "Error with Login", message: "There was an error with logged in. Please login again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func remove() {
        // function that removes all favorites from the array that don't have the right correct username
        for items in SavedItems.sharedInstance().favoritesArray {
            if items.userName != SavedItems.sharedInstance().userName {
                if let index = SavedItems.sharedInstance().favoritesArray.index(of: items) {
                    SavedItems.sharedInstance().favoritesArray.remove(at: index)
                }
            }
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
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
        // pass the drink info for the selected drink to the next view 
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
