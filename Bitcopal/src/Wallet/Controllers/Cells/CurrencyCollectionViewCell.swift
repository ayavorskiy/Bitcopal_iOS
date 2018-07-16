//
//  CurrencyCollectionViewCell.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/25/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currencyBackgroundView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        currencyBackgroundView.dropShadow(color: UIColor.Common.navBarShadow,
                                  opacity: 1,
                                  offSet: CGSize(width: 3.0, height: 3.0),
                                  radius: 4)
        
        imageView.contentMode = .scaleAspectFit
    }
}
