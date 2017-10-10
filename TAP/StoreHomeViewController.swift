//
//  ViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 7/28/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Firebase
import FirebaseAuthUI
import ReachabilitySwift
import CoreLocation

class StoreHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    // initalize all outlets
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var YTPlayerView: YTPlayerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    // initalize variables
    var storeItems = ["Beer", "Wine", "Liquor", "Extras"]
    var storePictures = [#imageLiteral(resourceName: "Beer"), #imageLiteral(resourceName: "Wine"), #imageLiteral(resourceName: "Liquor"), #imageLiteral(resourceName: "Extras")]
    var liquorName: String?
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    let reachability = Reachability()!
    var user: User?
    var displayName = "No name"
    let location = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TO DO: get users location
        
        // configureAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // check for reachbility
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func getLocation() {
    }
    
    @IBAction func signIn(_ sender: Any) {
        self.loginSession()
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
                self.loginSession()
            }
        }
    }
    
    func configureUI() {
        // set up flow layout
        let space:CGFloat = 12.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionWidth = (view.frame.size.width + (10 * space)) / 3.0
        // let heightDimension = (view.frame.size.height - (20 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimension)
        
        // call youtube video to youtube player
        self.YTPlayerView.load(withVideoId: "dd5Bde5j-sg")
    }
    
    func signedInStatus(isSignedIn: Bool) {
        // check if signed in the call this function and set these ui elements
        storeCollectionView.isHidden = !isSignedIn
        YTPlayerView.isHidden = !isSignedIn
        tabBarController?.tabBar.isHidden = !isSignedIn
        label.isHidden = !isSignedIn
        signInButton.isHidden = isSignedIn
        if isSignedIn {
            // configure UI and save username
            configureUI()
            SavedItems.sharedInstance().userName = self.displayName
        }
    }
    
    func loginSession() {
        // call the Firebase authentication view controller so user can login
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }

    
    @IBAction func logout(_ sender: Any) {
        // try logging out
        do {
            try Auth.auth().signOut()
        } catch {
            print("unable to sign out: \(error)")
        }
        // if logout is successful set user to nil than dismiss the view controller
        user = nil
        dismiss(animated: true, completion: nil)
    }
    
    func reachabilityChanged(note: Notification) {
        // check for changes in reachability
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            print("Reachable.")
        } else {
            let alertController = UIAlertController(title: "Error", message: "Check your internet connection.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    deinit {
        // deinitalize all observers and notifiers
        if _authHandle != nil {
            Auth.auth().removeStateDidChangeListener(_authHandle)
        }
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "cell"
        let cell = storeCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
        
        cell.label.text = storeItems[indexPath.row]
        cell.picture.image = storePictures[indexPath.row]
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell \(indexPath.row)")
        // check if liquor is clicked and segue to liquor or straight to table view controller
        if indexPath.row == 2 {
            performSegue(withIdentifier: "liquorSegue", sender: self)
        } else {
            liquorName = storeItems[indexPath.row]
            performSegue(withIdentifier: "storeSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "liquorSegue" {
            _ = segue.destination as! UIViewController
        } else if segue.identifier == "storeSegue" {
            let segue = segue.destination as! DrinkTableViewController
            segue.type = liquorName
        }
    }
    
}

