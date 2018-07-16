//
//  Currency.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/26/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

enum CurrencyType: String, Decodable {
    case bitcoin
    case etherium
    case litecoin
    case bitcostar
}

class Currency: NSObject {
    var image: UIImage
    var title: String
    var type: CurrencyType
    var isSelected: Bool
    
    init(with image: UIImage, title: String, type: CurrencyType, isSelected: Bool = false) {
        self.image = image
        self.title = title
        self.type = type
        self.isSelected = isSelected
    }
}
