//
//  LiquorStoreHomeViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/3/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit

class LiquorStoreHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // initalize variables
    var storeItems = ["Tequlia", "Bourbon", "Vodka", "Rum", "Gin", "Whiskey"]
    var storePictures = [#imageLiteral(resourceName: "Tequlia"), #imageLiteral(resourceName: "Bourbon"), #imageLiteral(resourceName: "Vodka"), #imageLiteral(resourceName: "Rum"), #imageLiteral(resourceName: "Gin"), #imageLiteral(resourceName: "Whiskey")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 12.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionWidth = (view.frame.size.width + (10 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
        
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
            performSegue(withIdentifier: "storeSegue", sender: self)
        }
        
    }
}
