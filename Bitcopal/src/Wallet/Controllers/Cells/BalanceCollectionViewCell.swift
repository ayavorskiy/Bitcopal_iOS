//
//  ExchangeRateCollectionViewCell.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/25/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!
    
    @IBAction func sendButtonPressed(_ sender: Any) {
    }
    @IBAction func receivedButtonPressed(_ sender: Any) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sendButton.dropShadow(color: UIColor.Common.navBarShadow,
                                          opacity: 1,
                                          offSet: CGSize(width: 3.0, height: 3.0),
                                          radius: 4)
        
        receiveButton.dropShadow(color: UIColor.Common.navBarShadow,
                              opacity: 1,
                              offSet: CGSize(width: 3.0, height: 3.0),
                              radius: 4)
    }
}
