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
    
    func sendTransaction(fromAddress: Address, toAddress: String, amount: Decimal, fee: Decimal, completion: @escaping (_ success: Bool, _ hash: String?) -> ()) {
        
        apiManager.fetchUnspentOutputs(address: fromAddress) { [unowned self](unspentOutputs, error) in
            if let error = error {
                print(error)
                completion(false, nil)
                return
            }
            
            guard let unspentOutputs = unspentOutputs else {
                completion(false, nil)
                return
            }
            
            self.coreManager.generateTransaction(fromAddress: fromAddress, toAddress: toAddress, amount: amount, fee: fee, unspentOutputs: unspentOutputs, completion: { (rawTx, error) in
                if let error = error {
                    print(error)
                    completion(false, nil)
                    return
                }
                
                guard let rawTx = rawTx else { completion(false, nil); return }
                
                self.apiManager.broadcastTransaction(rawTx: rawTx, completion: { (success, hash) in
                    completion(success, hash)
                })
            })
        }
    }
}
