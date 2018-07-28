//
//  Constants.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

struct Constants {
    
    struct BitCoinAPI {
        
        struct BlockchainInfo {
            
            private static let baseUrl = "https://blockchain.info"
            //static let singleAddress = {return baseUrl + "/rawaddr/"}()
            //static let latestBlock = {return baseUrl + "/latestblock"}()
            static let multiAddress = {return baseUrl + "/multiaddr?active="}()
            static let unspentOutputs = {return baseUrl + "/unspent?active="}()
            static let broadcast = {return baseUrl + "/blockchain/broadcast"}()
        }
        
        struct Blockchain {
            private static let baseUrl = "https://blockchain.com"
            static let transactionDetails = {return baseUrl + "/btc/tx/"}()
        }
        
        struct BlockExplorer {
            
            private static let baseUrl = "https://blockexplorer.com/api"
            static let historyTransactions = {return baseUrl + "/txs/?address="}()
            static let singleAddress = {return baseUrl + "/addr/"}()
        }
        
        struct Blockcypher {
            //FIXME: -- write your token
            static let broadcast = "https://api.blockcypher.com/v1/btc/main/txs/push?token=fd834448a60b429395bf993fd9fc5dd2"
        }
    }
}
