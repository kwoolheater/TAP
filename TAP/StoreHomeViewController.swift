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

class StoreHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // initalize all outlets
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var YTPlayerView: YTPlayerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    func configureAuth() {
        // listen for changes in auth state 
        _authHandle = Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
            if let activeUser = user {
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
        
        scrollView.contentSize.height = 750
    }
    
    func signedInStatus(isSignedIn: Bool) {
        if isSignedIn {
            configureUI()
        }
    }
    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(_authHandle)
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

