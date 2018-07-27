//
//  MultipleAddressBlockchainInfoResponse.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

struct MultipleAddressBlockchainInfoResponse : Codable {
    
    let recommend_include_fee : Bool?
    let info : MultipleAddressBlockchainInfoResponseInfo?
    let wallet : MultipleAddressBlockchainInfoResponseWallet?
    let addresses : [MultipleAddressBlockchainInfoResponseAddresses]?
    let txs : [MultipleAddressBlockchainInfoResponseTxs]?
    
    enum CodingKeys: String, CodingKey {
        
        case recommend_include_fee = "recommend_include_fee"
        case info
        case wallet
        case addresses = "addresses"
        case txs = "txs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recommend_include_fee = try values.decodeIfPresent(Bool.self, forKey: .recommend_include_fee)
        info = try MultipleAddressBlockchainInfoResponseInfo(from: decoder)
        wallet = try MultipleAddressBlockchainInfoResponseWallet(from: decoder)
        addresses = try values.decodeIfPresent([MultipleAddressBlockchainInfoResponseAddresses].self, forKey: .addresses)
        txs = try values.decodeIfPresent([MultipleAddressBlockchainInfoResponseTxs].self, forKey: .txs)
    }
}

struct MultipleAddressBlockchainInfoResponseAddresses : Codable {
    let address : String?
    let n_tx : Decimal?
    let total_received : Decimal?
    let total_sent : Decimal?
    let final_balance : Decimal?
    let change_index : Decimal?
    let account_index : Decimal?
    
    enum CodingKeys: String, CodingKey {
        
        case address = "address"
        case n_tx = "n_tx"
        case total_received = "total_received"
        case total_sent = "total_sent"
        case final_balance = "final_balance"
        case change_index = "change_index"
        case account_index = "account_index"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        n_tx = try values.decodeIfPresent(Decimal.self, forKey: .n_tx)
        total_received = try values.decodeIfPresent(Decimal.self, forKey: .total_received)
        total_sent = try values.decodeIfPresent(Decimal.self, forKey: .total_sent)
        final_balance = try values.decodeIfPresent(Decimal.self, forKey: .final_balance)
        change_index = try values.decodeIfPresent(Decimal.self, forKey: .change_index)
        account_index = try values.decodeIfPresent(Decimal.self, forKey: .account_index)
    }
    
}

struct MultipleAddressBlockchainInfoResponseInfo : Codable {
    let nconnected : Decimal?
    let conversion : Decimal?
    let symbol_local : MultipleAddressBlockchainInfoResponseSymbol_local?
    let symbol_btc : MultipleAddressBlockchainInfoResponseSymbol_btc?
    let latest_block : MultipleAddressBlockchainInfoResponseLatest_block?
    
    enum CodingKeys: String, CodingKey {
        
        case nconnected = "nconnected"
        case conversion = "conversion"
        case symbol_local
        case symbol_btc
        case latest_block
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nconnected = try values.decodeIfPresent(Decimal.self, forKey: .nconnected)
        conversion = try values.decodeIfPresent(Decimal.self, forKey: .conversion)
        symbol_local = try MultipleAddressBlockchainInfoResponseSymbol_local(from: decoder)
        symbol_btc = try MultipleAddressBlockchainInfoResponseSymbol_btc(from: decoder)
        latest_block = try MultipleAddressBlockchainInfoResponseLatest_block(from: decoder)
    }
    
}

struct MultipleAddressBlockchainInfoResponseInputs : Codable {
    let prev_out : MultipleAddressBlockchainInfoResponsePrev_out?
    let sequence : Decimal?
    let script : String?
    let witness : String?
    
    enum CodingKeys: String, CodingKey {
        
        case prev_out
        case sequence = "sequence"
        case script = "script"
        case witness = "witness"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prev_out = try MultipleAddressBlockchainInfoResponsePrev_out(from: decoder)
        sequence = try values.decodeIfPresent(Decimal.self, forKey: .sequence)
        script = try values.decodeIfPresent(String.self, forKey: .script)
        witness = try values.decodeIfPresent(String.self, forKey: .witness)
    }
    
}

struct MultipleAddressBlockchainInfoResponseLatest_block : Codable {
    let block_index : Decimal?
    let hash : String?
    let height : Decimal?
    let time : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case block_index = "block_index"
        case hash = "hash"
        case height = "height"
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        block_index = try values.decodeIfPresent(Decimal.self, forKey: .block_index)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        height = try values.decodeIfPresent(Decimal.self, forKey: .height)
        time = try values.decodeIfPresent(Double.self, forKey: .time)
    }
    
}

struct MultipleAddressBlockchainInfoResponseOut : Codable {
    let value : Decimal?
    let tx_index : Decimal?
    let n : Int?
    let spent : Bool?
    let script : String?
    let type : Int?
    let addr : String?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case tx_index = "tx_index"
        case n = "n"
        case spent = "spent"
        case script = "script"
        case type = "type"
        case addr = "addr"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Decimal.self, forKey: .value)
        tx_index = try values.decodeIfPresent(Decimal.self, forKey: .tx_index)
        n = try values.decodeIfPresent(Int.self, forKey: .n)
        spent = try values.decodeIfPresent(Bool.self, forKey: .spent)
        script = try values.decodeIfPresent(String.self, forKey: .script)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
    }
    
}

struct MultipleAddressBlockchainInfoResponsePrev_out : Codable {
    let value : Decimal?
    let tx_index : Decimal?
    let n : Int?
    let spent : Bool?
    let script : String?
    let type : Int?
    let addr : String?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case tx_index = "tx_index"
        case n = "n"
        case spent = "spent"
        case script = "script"
        case type = "type"
        case addr = "addr"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Decimal.self, forKey: .value)
        tx_index = try values.decodeIfPresent(Decimal.self, forKey: .tx_index)
        n = try values.decodeIfPresent(Int.self, forKey: .n)
        spent = try values.decodeIfPresent(Bool.self, forKey: .spent)
        script = try values.decodeIfPresent(String.self, forKey: .script)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
    }
    
}

struct MultipleAddressBlockchainInfoResponseSymbol_btc : Codable {
    let code : String?
    let symbol : String?
    let name : String?
    let conversion : Decimal?
    let symbolAppearsAfter : Bool?
    let local : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case symbol = "symbol"
        case name = "name"
        case conversion = "conversion"
        case symbolAppearsAfter = "symbolAppearsAfter"
        case local = "local"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        conversion = try values.decodeIfPresent(Decimal.self, forKey: .conversion)
        symbolAppearsAfter = try values.decodeIfPresent(Bool.self, forKey: .symbolAppearsAfter)
        local = try values.decodeIfPresent(Bool.self, forKey: .local)
    }
    
}

struct MultipleAddressBlockchainInfoResponseSymbol_local : Codable {
    let code : String?
    let symbol : String?
    let name : String?
    let conversion : Decimal?
    let symbolAppearsAfter : Bool?
    let local : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case symbol = "symbol"
        case name = "name"
        case conversion = "conversion"
        case symbolAppearsAfter = "symbolAppearsAfter"
        case local = "local"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        conversion = try values.decodeIfPresent(Decimal.self, forKey: .conversion)
        symbolAppearsAfter = try values.decodeIfPresent(Bool.self, forKey: .symbolAppearsAfter)
        local = try values.decodeIfPresent(Bool.self, forKey: .local)
    }
    
}

struct MultipleAddressBlockchainInfoResponseTxs : Codable {
    let hash : String?
    let ver : Int?
    let vin_sz : Decimal?
    let vout_sz : Decimal?
    let size : Decimal?
    let weight : Decimal?
    let fee : Decimal?
    let relayed_by : String?
    let lock_time : Double?
    let tx_index : Decimal?
    let double_spend : Bool?
    let result : Decimal?
    let balance : Decimal?
    let time : Double?
    let block_height : Decimal?
    let inputs : [MultipleAddressBlockchainInfoResponseInputs]?
    let out : [MultipleAddressBlockchainInfoResponseOut]?
    
    enum CodingKeys: String, CodingKey {
        
        case hash = "hash"
        case ver = "ver"
        case vin_sz = "vin_sz"
        case vout_sz = "vout_sz"
        case size = "size"
        case weight = "weight"
        case fee = "fee"
        case relayed_by = "relayed_by"
        case lock_time = "lock_time"
        case tx_index = "tx_index"
        case double_spend = "double_spend"
        case result = "result"
        case balance = "balance"
        case time = "time"
        case block_height = "block_height"
        case inputs = "inputs"
        case out = "out"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        ver = try values.decodeIfPresent(Int.self, forKey: .ver)
        vin_sz = try values.decodeIfPresent(Decimal.self, forKey: .vin_sz)
        vout_sz = try values.decodeIfPresent(Decimal.self, forKey: .vout_sz)
        size = try values.decodeIfPresent(Decimal.self, forKey: .size)
        weight = try values.decodeIfPresent(Decimal.self, forKey: .weight)
        fee = try values.decodeIfPresent(Decimal.self, forKey: .fee)
        relayed_by = try values.decodeIfPresent(String.self, forKey: .relayed_by)
        lock_time = try values.decodeIfPresent(Double.self, forKey: .lock_time)
        tx_index = try values.decodeIfPresent(Decimal.self, forKey: .tx_index)
        double_spend = try values.decodeIfPresent(Bool.self, forKey: .double_spend)
        result = try values.decodeIfPresent(Decimal.self, forKey: .result)
        balance = try values.decodeIfPresent(Decimal.self, forKey: .balance)
        time = try values.decodeIfPresent(Double.self, forKey: .time)
        block_height = try values.decodeIfPresent(Decimal.self, forKey: .block_height)
        inputs = try values.decodeIfPresent([MultipleAddressBlockchainInfoResponseInputs].self, forKey: .inputs)
        out = try values.decodeIfPresent([MultipleAddressBlockchainInfoResponseOut].self, forKey: .out)
    }
    
}

struct MultipleAddressBlockchainInfoResponseWallet : Codable {
    let n_tx : Decimal?
    let n_tx_filtered : Decimal?
    let total_received : Decimal?
    let total_sent : Decimal?
    let final_balance : Decimal?
    
    enum CodingKeys: String, CodingKey {
        
        case n_tx = "n_tx"
        case n_tx_filtered = "n_tx_filtered"
        case total_received = "total_received"
        case total_sent = "total_sent"
        case final_balance = "final_balance"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        n_tx = try values.decodeIfPresent(Decimal.self, forKey: .n_tx)
        n_tx_filtered = try values.decodeIfPresent(Decimal.self, forKey: .n_tx_filtered)
        total_received = try values.decodeIfPresent(Decimal.self, forKey: .total_received)
        total_sent = try values.decodeIfPresent(Decimal.self, forKey: .total_sent)
        final_balance = try values.decodeIfPresent(Decimal.self, forKey: .final_balance)
    }
    
}
