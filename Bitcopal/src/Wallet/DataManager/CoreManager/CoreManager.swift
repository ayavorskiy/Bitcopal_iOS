//
//  CoreManager.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 11.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

class CoreManager {
    
    private let bitCoinCore = BitCoinCore()
    
    func createWallet(currencyType: CurrencyType, completion: (_ address: Address)->()) {
        switch currencyType {
        case .bitcoin:
            return bitCoinCore.createWallet(completion: completion)
        default: break
        }
    }
    
    func generateTransaction(fromAddress: Address, toAddress: String, amount: Decimal, fee: Decimal, unspentOutputs: [UnspentOutputBlockchainInfoResponse], completion: (_ rawTx: String?, _ error: String?) ->()) {
        switch fromAddress.currency {
        case .bitcoin:
            bitCoinCore.generateTransaction(fromAddress: fromAddress, toAddress: toAddress, amount: amount, fee: fee, unspentOutputs: unspentOutputs, completion: completion)
        default: break
        }
    }
}
