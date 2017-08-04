//
//  DrinkTableView.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/4/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import Firebase

class DrinkTableViewController: UITableViewController {
    
    // declare variables
    var ref: DatabaseReference!
    var items: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle!
    
    // outlets :)
    @IBOutlet var drinkTable: UITableView!
    
    // MARK: config
    // configure database
    func configureDatabase() {
        ref = Database.database().reference()
        _refHandle = ref.child("Tequlia").observe(.childAdded) { (snapshot: DataSnapshot) in
            self.items.append(snapshot)
            self.drinkTable.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: .automatic)
            print(snapshot)
        }
    }
    
    deinit {
        ref.child("Tequlia").removeObserver(withHandle: _refHandle)
    }
    
    // MARK: table view 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell: UITableViewCell = drinkTable.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        // unpack item from firebase snapshot
        let itemSnapshot = items[indexPath.row]
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
