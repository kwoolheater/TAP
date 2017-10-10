//
//  StoreCollectionViewCell.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 7/31/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    // declare outlates for collection view cell
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    // create init message that sets cells UI compenents
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.2
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.clipsToBounds = true
    }

}
