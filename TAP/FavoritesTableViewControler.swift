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
import FirebaseAuthUI

class FavoritesTableViewController: CoreDataViewController {
    
    // declare variables
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var sentDrink: Drink?
    var reloadData: Bool?
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "No name"
    
    // declare outlets for the table view
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var button: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuth()
    }
    
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
        if button.title != "Sign In" {
            do {
                try Auth.auth().signOut()
            } catch {
                print("unable to sign out: \(error)")
            }
            // if logout is successful set user to nil than dismiss the view controller
            user = nil
            dismiss(animated: true, completion: nil)
        } else {
            loginSession()
        }
    }
    
    func signedInStatus(isSignedIn: Bool) {
        // check if signed in the call this function and set these ui elements
        self.button.title = "Sign In"
        if isSignedIn {
            // configure UI and save username
            SavedItems.sharedInstance().userName = self.displayName
            self.button.title = "Logout"
        }
    }
    
    func configureAuth() {
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
                    self.signedInStatus(isSignedIn: true)
                }
            } else {
                // user must sign in
                self.signedInStatus(isSignedIn: false)
            }
        }
    }
    
    func loginSession() {
        // call the Firebase authentication view controller so user can login
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    deinit {
        // deinitalize all observers and notifiers
        if _authHandle != nil {
            Auth.auth().removeStateDidChangeListener(_authHandle)
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
