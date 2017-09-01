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

class StoreHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    // initalize all outlets
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var YTPlayerView: YTPlayerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backgroundBlur: UIVisualEffectView!
    
    // initalize variables
    var storeItems = ["Beer", "Wine", "Liquor", "Extras"]
    var storePictures = [#imageLiteral(resourceName: "Beer"), #imageLiteral(resourceName: "Wine"), #imageLiteral(resourceName: "Liquor"), #imageLiteral(resourceName: "Extras")]
    var liquorName: String?
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    
    var user: User?
    var displayName = "No name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureAuth()
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
                    self.signedInStatus(isSignedIn: true)
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
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
        
        self.YTPlayerView.load(withVideoId: "IGE9qpICfSw")
    }
    
    func signedInStatus(isSignedIn: Bool) {
        storeCollectionView.isHidden = !isSignedIn
        YTPlayerView.isHidden = !isSignedIn
        tabBarController?.tabBar.isHidden = !isSignedIn
        label.isHidden = !isSignedIn
        signInButton.isHidden = isSignedIn
        if isSignedIn {
            // remove background blur (will use when showing image messages)
            configureUI()
        }
    }
    
    func loginSession() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
                self.present(authViewController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Check your internet connection.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("unable to sign out: \(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        if _authHandle != nil {
            Auth.auth().removeStateDidChangeListener(_authHandle)
        }
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

