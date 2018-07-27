//
//  ApiManager.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

class ApiManager {
    
    private let bitCoinAPI = BitCoinAPI()
    
    func getSingleAddressInfo(address: Address, completion: @escaping (_ addressInfo: SingleAddressInfo?, _ error: String?)->()) {
        switch address.currency {
        case .bitcoin:
            return bitCoinAPI.fetchSingleAddressInfo(address: address, completion: completion)
        default: break
        }
    }
    
    func fetchUnspentOutputs(address: Address, completion: @escaping (_ UnspentOutputs: [UnspentOutputBlockchainInfoResponse]?, _ error: String?) -> ()) {
        switch address.currency {
        case .bitcoin:
            return bitCoinAPI.fetchUnspentOutputs(address: address, completion: completion)
        default: break
        }
    }
    
    func broadcastTransaction(rawTx: String, completion: @escaping (_ success: Bool) -> ()) {
        return bitCoinAPI.broadcastTransaction(rawTx: rawTx, completion: completion)
    }
}
