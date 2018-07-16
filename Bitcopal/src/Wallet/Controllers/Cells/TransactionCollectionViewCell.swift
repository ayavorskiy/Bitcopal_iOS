//
//  TransactionCollectionViewCell.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/29/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

class TransactionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amauntLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amaountUSDLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.tintColor = UIColor(rgbColorCodeRed: 74, green: 74, blue: 74, alpha: 1)
    }
}
