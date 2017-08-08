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
    var ref: DatabaseReference!
    var items: [DataSnapshot]! = []
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
        // _refHandle = ref.child("Tequlia").observe(.childAdded) { (snapshot: DataSnapshot) in
        //    self.items.append(snapshot)
        //    self.drinkTable.insertRows(at: [IndexPath(row: self.items.count - 1, section: 0)], with: .automatic)
        //    print(snapshot)
        //}
        //DispatchQueue.main.async {
        //    self.drinkTable.reloadData()
        //}
    }
    
    func retrieveData() {
        
        _refHandle = ref.child("Tequlia").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary)
            } else {
                print("error")
            }
        
        })
        
        
    }
    
    deinit {
        ref.child("Tequlia").removeObserver(withHandle: _refHandle)
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
        // unpack item from firebase snapshot
        
        
        let itemSnapshot: DataSnapshot = items[indexPath.row]
        let item = itemSnapshot.value as! [String:String]
        print(item)
        let name = item["prices"] ?? "[username]"
        print (name)
        cell.textLabel?.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
