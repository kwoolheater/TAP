//
//  DetailViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 8/16/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    // declare variables
    var drink: Drink?
    
    // initalize outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = drink?.name
        price.text = "Price: $\(drink?.price750mL ?? 0)"
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        
    }
    
    @IBAction func favorite(_ sender: Any) {
        favoritesButton.tintColor = .red
    }
    
    
}
