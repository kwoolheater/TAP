//
//  StoreCollectionViewCell.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 7/31/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.clipsToBounds = true
    }

}
