//
//  SingleAddressBlockchainInfoResponse.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

//import Foundation
//
//struct SingleAddressBlockchainInfoResponse: Codable {
//    
//    let hash160 : String?
//    let address : String?
//    let n_tx : Decimal?
//    let total_received : Decimal?
//    let total_sent : Decimal?
//    let final_balance : Decimal?
//    let txs : [SingleAddressBlockchainInfoResponseTxs]?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case hash160 = "hash160"
//        case address = "address"
//        case n_tx = "n_tx"
//        case total_received = "total_received"
//        case total_sent = "total_sent"
//        case final_balance = "final_balance"
//        case txs = "txs"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        hash160 = try values.decodeIfPresent(String.self, forKey: .hash160)
//        address = try values.decodeIfPresent(String.self, forKey: .address)
//        n_tx = try values.decodeIfPresent(Decimal.self, forKey: .n_tx)
//        total_received = try values.decodeIfPresent(Decimal.self, forKey: .total_received)
//        total_sent = try values.decodeIfPresent(Decimal.self, forKey: .total_sent)
//        final_balance = try values.decodeIfPresent(Decimal.self, forKey: .final_balance)
//        txs = try values.decodeIfPresent([SingleAddressBlockchainInfoResponseTxs].self, forKey: .txs)
//    }
//    
//}
//
//struct SingleAddressBlockchainInfoResponseTxs : Codable {
//    let ver : Int?
//    let inputs : [SingleAddressBlockchainInfoResponseTxsInputs]?
//    let weight : Decimal?
//    let block_height : Decimal?
//    let relayed_by : String?
//    let out : [SingleAddressBlockchainInfoResponseTxsOut]?
//    let lock_time : Decimal?
//    let result : Decimal?
//    let size : Decimal?
//    let time : Double?
//    let tx_index : Decimal?
//    let vin_sz : Decimal?
//    let hash : String?
//    let vout_sz : Decimal?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case ver = "ver"
//        case inputs = "inputs"
//        case weight = "weight"
//        case block_height = "block_height"
//        case relayed_by = "relayed_by"
//        case out = "out"
//        case lock_time = "lock_time"
//        case result = "result"
//        case size = "size"
//        case time = "time"
//        case tx_index = "tx_index"
//        case vin_sz = "vin_sz"
//        case hash = "hash"
//        case vout_sz = "vout_sz"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        ver = try values.decodeIfPresent(Int.self, forKey: .ver)
//        inputs = try values.decodeIfPresent([SingleAddressBlockchainInfoResponseTxsInputs].self, forKey: .inputs)
//        weight = try values.decodeIfPresent(Decimal.self, forKey: .weight)
//        block_height = try values.decodeIfPresent(Decimal.self, forKey: .block_height)
//        relayed_by = try values.decodeIfPresent(String.self, forKey: .relayed_by)
//        out = try values.decodeIfPresent([SingleAddressBlockchainInfoResponseTxsOut].self, forKey: .out)
//        lock_time = try values.decodeIfPresent(Decimal.self, forKey: .lock_time)
//        result = try values.decodeIfPresent(Decimal.self, forKey: .result)
//        size = try values.decodeIfPresent(Decimal.self, forKey: .size)
//        time = try values.decodeIfPresent(Double.self, forKey: .time)
//        tx_index = try values.decodeIfPresent(Decimal.self, forKey: .tx_index)
//        vin_sz = try values.decodeIfPresent(Decimal.self, forKey: .vin_sz)
//        hash = try values.decodeIfPresent(String.self, forKey: .hash)
//        vout_sz = try values.decodeIfPresent(Decimal.self, forKey: .vout_sz)
//    }
//    
//}
//
//struct SingleAddressBlockchainInfoResponseTxsInputs : Codable {
//    let sequence : Decimal?
//    let witness : String?
//    let prev_out : SingleAddressBlockchainInfoResponseTxsInputsPrev_out?
//    let script : String?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case sequence = "sequence"
//        case witness = "witness"
//        case prev_out = "prev_out"
//        case script = "script"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        sequence = try values.decodeIfPresent(Decimal.self, forKey: .sequence)
//        witness = try values.decodeIfPresent(String.self, forKey: .witness)
//        prev_out = try values.decodeIfPresent(SingleAddressBlockchainInfoResponseTxsInputsPrev_out.self, forKey: .prev_out)
//        //BlockchainInfoResponseTxsInputsPrev_out(from: decoder)
//        script = try values.decodeIfPresent(String.self, forKey: .script)
//    }
//    
//}
//
//struct SingleAddressBlockchainInfoResponseTxsOut : Codable {
//    let spent : Bool?
//    let tx_index : Decimal?
//    let type : Int?
//    let addr : String?
//    let value : Decimal?
//    let n : Int?
//    let script : String?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case spent = "spent"
//        case tx_index = "tx_index"
//        case type = "type"
//        case addr = "addr"
//        case value = "value"
//        case n = "n"
//        case script = "script"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        spent = try values.decodeIfPresent(Bool.self, forKey: .spent)
//        tx_index = try values.decodeIfPresent(Decimal.self, forKey: .tx_index)
//        type = try values.decodeIfPresent(Int.self, forKey: .type)
//        addr = try values.decodeIfPresent(String.self, forKey: .addr)
//        value = try values.decodeIfPresent(Decimal.self, forKey: .value)
//        n = try values.decodeIfPresent(Int.self, forKey: .n)
//        script = try values.decodeIfPresent(String.self, forKey: .script)
//    }
//    
//}
//
//struct SingleAddressBlockchainInfoResponseTxsInputsPrev_out : Codable {
//    let spent : Bool?
//    let tx_index : Decimal?
//    let type : Int?
//    let addr : String?
//    let value : Decimal?
//    let n : Int?
//    let script : String?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case spent = "spent"
//        case tx_index = "tx_index"
//        case type = "type"
//        case addr = "addr"
//        case value = "value"
//        case n = "n"
//        case script = "script"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        spent = try values.decodeIfPresent(Bool.self, forKey: .spent)
//        tx_index = try values.decodeIfPresent(Decimal.self, forKey: .tx_index)
//        type = try values.decodeIfPresent(Int.self, forKey: .type)
//        addr = try values.decodeIfPresent(String.self, forKey: .addr)
//        value = try values.decodeIfPresent(Decimal.self, forKey: .value)
//        n = try values.decodeIfPresent(Int.self, forKey: .n)
//        script = try values.decodeIfPresent(String.self, forKey: .script)
//    }
//    
//}
