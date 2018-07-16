//
//  MainScreenDTO.swift
//  Wallet
//
//  Created by Костюкевич Илья on 7/2/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

struct MainScreen: Decodable {
    let balance: Int
    let transactions: [Transactions]
    
    enum CodingKeys : String, CodingKey {
        case balance = "final_balance"
        case transactions = "txs"
    }
}

struct Transactions: Decodable {
    let out: [OutTransaction]
    let hash: String
    let time: Int
    
    enum CodingKeys : String, CodingKey {
        case out = "out"
        case hash = "hash"
        case time = "time"
    }
}

struct OutTransaction: Decodable {
    let address: String
    let value: Int
    
    enum CodingKeys : String, CodingKey {
        case address = "addr"
        case value = "value"
    }
}

struct RepresentationTransaction {
    let address: String
    let value: Int
    let time: Int
}

class MainScreenDTO: NSObject {

    

}
