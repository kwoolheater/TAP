//
//  ViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 7/28/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class StoreHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // initalize all outlets
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var YTPlayerView: YTPlayerView!
    
    // initalize variables
    var storeItems = ["Beer", "Wine", "Liquor", "Extras"]
    var storePictures = [#imageLiteral(resourceName: "Beer"), #imageLiteral(resourceName: "Wine"), #imageLiteral(resourceName: "Liquor"), #imageLiteral(resourceName: "Extras")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // set up flow layout
        let space:CGFloat = 12.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        // let heightDimension = (view.frame.size.height - (20 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.YTPlayerView.load(withVideoId: "M7lc1UVf-VE")
    }

    // TODO: initalize collection view
    // create array of items
    
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
    }
    
    
    
}

