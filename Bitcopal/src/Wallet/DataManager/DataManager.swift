//
//  DataManager.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation
import KeychainAccess

class DataManager {
    
    private static let sharedInstance = DataManager()
    static var shared: DataManager { return sharedInstance }
    private init() {}
    
    let apiManager = ApiManager()
    let coreManager = CoreManager()
    
    func createWallet(currencyType: CurrencyType, completion: (_ address: Address)->()) {
        coreManager.createWallet(currencyType: currencyType, completion: completion)
    }
    
    func saveWallet(address: Address) {
        let keychain = Keychain()
        
        keychain[data: "\(address.currency.rawValue)seed"] = address.seed
        keychain[string: "\(address.currency.rawValue)address"] = address.address
        keychain[string: "\(address.currency.rawValue)privateKey"] = address.privateKey
    }
    
    func getWalletAddress(type: CurrencyType) -> Address? {
        let keychain = Keychain()
        
        guard let address = keychain[string: "\(type.rawValue)address"] else { return nil }
        guard let privateKey = keychain[string: "\(type.rawValue)privateKey"] else { return nil }
        
        return Address(address: address, currency: type, privateKey: privateKey, seed: keychain[data: "\(type.rawValue)seed"])
    }
    
    func sendTransaction(fromAddress: Address, toAddress: String, amount: Decimal, fee: Decimal, completion: @escaping (_ success: Bool) -> ()) {
        
        apiManager.fetchUnspentOutputs(address: fromAddress) { [unowned self](unspentOutputs, error) in
            guard error != nil else { completion(false); print(error); return }
            guard let unspentOutputs = unspentOutputs else { completion(false); return }
            
            self.coreManager.generateTransaction(fromAddress: fromAddress, toAddress: toAddress, amount: amount, fee: fee, unspentOutputs: unspentOutputs, completion: { (rawTx, error) in
                guard error != nil else { completion(false); print(error); return }
                guard let rawTx = rawTx else { completion(false); return }
                
                self.apiManager.broadcastTransaction(rawTx: rawTx, completion: { (success) in
                    completion(success)
                })
            })
        }
    }
}
