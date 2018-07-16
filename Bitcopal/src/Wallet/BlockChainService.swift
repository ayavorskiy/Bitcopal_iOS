//
//  BlockChainService.swift
//  Wallet
//
//  Created by Костюкевич Илья on 02.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

let bitcoinExchangeRate: Double = 6599.63

final class BlockChainService: NSObject {
   
//    public func getBalance() -> Decimal {
//        let blockStore = try! SQLiteBlockStore.default()
//        let wallet = AppController.shared.wallet
//
//        if let address = try? wallet?.receiveAddress(), address != nil {
//            let balance: Int64 = try! blockStore.calculateBlance(address: address!)
//            let decimal = Decimal(balance)
//
//            return decimal / Decimal(100000000)
//        }
//
//        return 0
//    }
//
//    public func getExchangeRate() -> Decimal {
//        let balance = getBalance()
//        
//        return balance * bitcoinExchangeRate
//    }
//
//    public func getTransactions() -> [Payment] {
//        let blockStore = try! SQLiteBlockStore.default()
//        let wallet = AppController.shared.wallet
//
//        if let address = try? wallet?.receiveAddress(), address != nil {
//            let payments = try! blockStore.transactions(address: address!)
//
//            return payments
//        }
//
//        return [Payment]()
//    }
    
    func getCurrenies() -> [Currency] {
        let array = [Currency(with: UIImage(named: "im_bitcoin")!, title: "BTС", type: .bitcoin, isSelected: true),
                     Currency(with: UIImage(named: "im_ephir")!, title: "Etherium", type: .etherium),
                     Currency(with: UIImage(named: "im_l")!, title: "Litecoin", type: .litecoin),
                     Currency(with: UIImage(named: "im_bitcostar")!, title: "Bitcostar", type: .bitcostar)]
        
        return array
    }
    
    public func checkBalance( onCompletion: @escaping (Double) -> Void) {
        let address = receiveAddress()
        let url = URL(string: "https://blockchain.info/q/addressbalance/" + address)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                debugPrint("Error loading Bitcoin wallet balance")
                return
            }
            
            let dataString = String(data: data!, encoding: String.Encoding.utf8)
            let satoshiBalance = Int(dataString!)
            
            guard satoshiBalance != nil else {
                // TODO: Error handling
                return
            }
            
            let btcBalance = Double(Double(satoshiBalance!)/100000000.0)
            onCompletion(btcBalance)
        }
        
        dataTask.resume()
    }
    
    public func checkTransactions( onCompletion: @escaping ([RepresentationTransaction]) -> Void) {
        let address = receiveAddress()
        let url = URL(string: "https://blockchain.info/address/\(address)?format=json")
        
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                debugPrint("Error loading Bitcoin wallet balance")
                return
            }
           
            guard let data = data else {return}
            
            guard let object = try? JSONDecoder().decode(MainScreen.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            
            var trxs = [RepresentationTransaction]()
            
            object.transactions.forEach({ (transaction) in
                guard let searchedTransaction = transaction.out.first(where: {$0.address == address}) else {return}
                
                let trx = RepresentationTransaction(address:  searchedTransaction.address, value: searchedTransaction.value, time: transaction.time)
                trxs.append(trx)
            })
            
            
            onCompletion(trxs)
        }
        
        dataTask.resume()
    }
    
    func receiveAddress() -> String {
//        let wallet = AppController.shared.wallet!
//        let externalIndex = AppController.shared.externalIndex
        //FIXME: ---
        //let address = try! wallet.receiveAddress(index: externalIndex)
        
        return String()//address.base58
    }
}
