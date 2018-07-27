//
//  UnspentOutputsBlockchainInfoResponse.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

struct UnspentOutputsBlockchainInfoResponse : Codable {
    let unspent_outputs : [UnspentOutputBlockchainInfoResponse]
    
    enum CodingKeys: String, CodingKey {
        
        case unspent_outputs = "unspent_outputs"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        unspent_outputs = try values.decode([UnspentOutputBlockchainInfoResponse].self, forKey: .unspent_outputs)
    }
    
}

struct UnspentOutputBlockchainInfoResponse : Codable {
    let tx_hash : String
    let tx_hash_big_endian : String
    let tx_index : Decimal
    let tx_output_n : Int
    let script : String
    let value : Decimal
    let value_hex : String
    let confirmations : Decimal
    
    enum CodingKeys: String, CodingKey {
        
        case tx_hash = "tx_hash"
        case tx_hash_big_endian = "tx_hash_big_endian"
        case tx_index = "tx_index"
        case tx_output_n = "tx_output_n"
        case script = "script"
        case value = "value"
        case value_hex = "value_hex"
        case confirmations = "confirmations"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tx_hash = try values.decode(String.self, forKey: .tx_hash)
        tx_hash_big_endian = try values.decode(String.self, forKey: .tx_hash_big_endian)
        tx_index = try values.decode(Decimal.self, forKey: .tx_index)
        tx_output_n = try values.decode(Int.self, forKey: .tx_output_n)
        script = try values.decode(String.self, forKey: .script)
        value = try values.decode(Decimal.self, forKey: .value)
        value_hex = try values.decode(String.self, forKey: .value_hex)
        confirmations = try values.decode(Decimal.self, forKey: .confirmations)
    }
    
}
