//
//  Transaction.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

struct Transaction {
    
    let currency: CurrencyType
    let type: TransactionType
    let result: Decimal
    let convertedResult: Decimal? = nil
    let date: Date
    let address: String
    let fee: Decimal
    let confirmations: Decimal
    let id: String

}

enum TransactionType {
    case receipt
    case send
}
