//
//  Balance.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

import Foundation

struct Balance: Decodable {
    
    var value: Decimal
    
    init(value: Decimal) {
        self.value = value
    }
}
