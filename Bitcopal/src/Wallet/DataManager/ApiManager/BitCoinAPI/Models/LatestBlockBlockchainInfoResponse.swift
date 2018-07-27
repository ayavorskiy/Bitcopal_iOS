//
//  LatestBlockBlockchainInfoResponse.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

//import Foundation
//
//struct LatestBlockBlockchainInfoResponse : Codable {
//    let hash : String?
//    let time : Double?
//    let block_index : Decimal?
//    let height : Decimal?
//    let txIndexes : [Decimal]?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case hash = "hash"
//        case time = "time"
//        case block_index = "block_index"
//        case height = "height"
//        case txIndexes = "txIndexes"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        hash = try values.decodeIfPresent(String.self, forKey: .hash)
//        time = try values.decodeIfPresent(Double.self, forKey: .time)
//        block_index = try values.decodeIfPresent(Decimal.self, forKey: .block_index)
//        height = try values.decodeIfPresent(Decimal.self, forKey: .height)
//        txIndexes = try values.decodeIfPresent([Decimal].self, forKey: .txIndexes)
//    }
//    
//}
