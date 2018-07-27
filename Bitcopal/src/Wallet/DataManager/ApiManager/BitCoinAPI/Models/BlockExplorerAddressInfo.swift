//
//  BlockExplorerAddressInfo.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 27.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation
struct BlockExplorerAddressInfo : Codable {
    let addrStr : String?
    let balance : Decimal?
    let balanceSat : Decimal?
    let totalReceived : Decimal?
    let totalReceivedSat : Decimal?
    let totalSent : Decimal?
    let totalSentSat : Decimal?
    let unconfirmedBalance : Decimal?
    let unconfirmedBalanceSat : Decimal?
    let unconfirmedTxApperances : Decimal?
    let txApperances : Decimal?
    let transactions : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case addrStr = "addrStr"
        case balance = "balance"
        case balanceSat = "balanceSat"
        case totalReceived = "totalReceived"
        case totalReceivedSat = "totalReceivedSat"
        case totalSent = "totalSent"
        case totalSentSat = "totalSentSat"
        case unconfirmedBalance = "unconfirmedBalance"
        case unconfirmedBalanceSat = "unconfirmedBalanceSat"
        case unconfirmedTxApperances = "unconfirmedTxApperances"
        case txApperances = "txApperances"
        case transactions = "transactions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addrStr = try values.decodeIfPresent(String.self, forKey: .addrStr)
        balance = try values.decodeIfPresent(Decimal.self, forKey: .balance)
        balanceSat = try values.decodeIfPresent(Decimal.self, forKey: .balanceSat)
        totalReceived = try values.decodeIfPresent(Decimal.self, forKey: .totalReceived)
        totalReceivedSat = try values.decodeIfPresent(Decimal.self, forKey: .totalReceivedSat)
        totalSent = try values.decodeIfPresent(Decimal.self, forKey: .totalSent)
        totalSentSat = try values.decodeIfPresent(Decimal.self, forKey: .totalSentSat)
        unconfirmedBalance = try values.decodeIfPresent(Decimal.self, forKey: .unconfirmedBalance)
        unconfirmedBalanceSat = try values.decodeIfPresent(Decimal.self, forKey: .unconfirmedBalanceSat)
        unconfirmedTxApperances = try values.decodeIfPresent(Decimal.self, forKey: .unconfirmedTxApperances)
        txApperances = try values.decodeIfPresent(Decimal.self, forKey: .txApperances)
        transactions = try values.decodeIfPresent([String].self, forKey: .transactions)
    }
    
}
