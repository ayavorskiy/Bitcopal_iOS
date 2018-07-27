//
//  BlockExplorerTransactionHistory.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 27.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

struct BlockExplorerTransactionHistory : Codable {
    let pagesTotal : Int?
    let txs : [Txs]?
    
    enum CodingKeys: String, CodingKey {
        
        case pagesTotal = "pagesTotal"
        case txs = "txs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pagesTotal = try values.decodeIfPresent(Int.self, forKey: .pagesTotal)
        txs = try values.decodeIfPresent([Txs].self, forKey: .txs)
    }
    
}

struct ScriptPubKey : Codable {
    let hex : String?
    let asm : String?
    let addresses : [String]?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        
        case hex = "hex"
        case asm = "asm"
        case addresses = "addresses"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hex = try values.decodeIfPresent(String.self, forKey: .hex)
        asm = try values.decodeIfPresent(String.self, forKey: .asm)
        addresses = try values.decodeIfPresent([String].self, forKey: .addresses)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}

struct ScriptSig : Codable {
    let asm : String?
    let hex : String?
    
    enum CodingKeys: String, CodingKey {
        
        case asm = "asm"
        case hex = "hex"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asm = try values.decodeIfPresent(String.self, forKey: .asm)
        hex = try values.decodeIfPresent(String.self, forKey: .hex)
    }
    
}

struct Txs : Codable {
    let txid : String?
    let version : Int?
    let locktime : Decimal?
    let vin : [Vin]?
    let vout : [Vout]?
    let blockheight : Decimal?
    let confirmations : Decimal?
    let time : Double?
    let valueOut : Decimal?
    let size : Decimal?
    let valueIn : Decimal?
    let fees : Decimal?
    
    enum CodingKeys: String, CodingKey {
        
        case txid = "txid"
        case version = "version"
        case locktime = "locktime"
        case vin = "vin"
        case vout = "vout"
        case blockheight = "blockheight"
        case confirmations = "confirmations"
        case time = "time"
        case valueOut = "valueOut"
        case size = "size"
        case valueIn = "valueIn"
        case fees = "fees"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        txid = try values.decodeIfPresent(String.self, forKey: .txid)
        version = try values.decodeIfPresent(Int.self, forKey: .version)
        locktime = try values.decodeIfPresent(Decimal.self, forKey: .locktime)
        vin = try values.decodeIfPresent([Vin].self, forKey: .vin)
        vout = try values.decodeIfPresent([Vout].self, forKey: .vout)
        blockheight = try values.decodeIfPresent(Decimal.self, forKey: .blockheight)
        confirmations = try values.decodeIfPresent(Decimal.self, forKey: .confirmations)
        time = try values.decodeIfPresent(Double.self, forKey: .time)
        valueOut = try values.decodeIfPresent(Decimal.self, forKey: .valueOut)
        size = try values.decodeIfPresent(Decimal.self, forKey: .size)
        valueIn = try values.decodeIfPresent(Decimal.self, forKey: .valueIn)
        fees = try values.decodeIfPresent(Decimal.self, forKey: .fees)
    }
    
}

struct Vin : Codable {
    let txid : String?
    let vout : Int?
    let scriptSig : ScriptSig?
    let sequence : Decimal?
    let n : Int?
    let addr : String?
    let valueSat : Decimal?
    let value : Decimal?
    let doubleSpentTxID : String?
    
    enum CodingKeys: String, CodingKey {
        
        case txid = "txid"
        case vout = "vout"
        case scriptSig = "scriptSig"
        case sequence = "sequence"
        case n = "n"
        case addr = "addr"
        case valueSat = "valueSat"
        case value = "value"
        case doubleSpentTxID = "doubleSpentTxID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        txid = try values.decodeIfPresent(String.self, forKey: .txid)
        vout = try values.decodeIfPresent(Int.self, forKey: .vout)
        scriptSig = try values.decodeIfPresent(ScriptSig.self, forKey: .scriptSig)
        sequence = try values.decodeIfPresent(Decimal.self, forKey: .sequence)
        n = try values.decodeIfPresent(Int.self, forKey: .n)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
        valueSat = try values.decodeIfPresent(Decimal.self, forKey: .valueSat)
        value = try values.decodeIfPresent(Decimal.self, forKey: .value)
        doubleSpentTxID = try values.decodeIfPresent(String.self, forKey: .doubleSpentTxID)
    }
    
}

struct Vout : Codable {
    let value : String?
    let n : Int?
    let scriptPubKey : ScriptPubKey?
    let spentTxId : String?
    let spentIndex : Decimal?
    let spentHeight : Decimal?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case n = "n"
        case scriptPubKey = "scriptPubKey"
        case spentTxId = "spentTxId"
        case spentIndex = "spentIndex"
        case spentHeight = "spentHeight"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        n = try values.decodeIfPresent(Int.self, forKey: .n)
        scriptPubKey = try values.decodeIfPresent(ScriptPubKey.self, forKey: .scriptPubKey)
        spentTxId = try values.decodeIfPresent(String.self, forKey: .spentTxId)
        spentIndex = try values.decodeIfPresent(Decimal.self, forKey: .spentIndex)
        spentHeight = try values.decodeIfPresent(Decimal.self, forKey: .spentHeight)
    }
    
}
