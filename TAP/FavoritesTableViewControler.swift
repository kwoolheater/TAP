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
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            SavedItems.sharedInstance().favoritesArray = try stack.context.fetch(fr) as! [Drink]
        } catch {
            fatalError("Could not fetch favorites.")
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
