//
//  Address.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

struct Address: Decodable {
    
    var id: String?
    let address: String
    let currency: CurrencyType
    let name: String?
    var count: Decimal?
    let mnemonic: [String]?
    var privateKey: String?
    var heshedPrivateKey: String?
    var encrypted: Bool?
    var seed: Data?
    
    init(id: String, address: String, currency: CurrencyType, name: String) {
        self.id = id
        self.address = address
        self.currency = currency
        self.name = name
        self.count = nil
        self.mnemonic = nil
        self.privateKey = nil
        self.encrypted = nil
    }
    
    init(address: String, currency: CurrencyType, mnemonic: [String]? = nil, privateKey: String, seed: Data? = nil) {
        self.id = nil
        self.address = address
        self.currency = currency
        self.name = nil
        self.count = nil
        self.mnemonic = mnemonic
        self.privateKey = privateKey
        self.encrypted = nil
        self.seed = seed
    }
}
