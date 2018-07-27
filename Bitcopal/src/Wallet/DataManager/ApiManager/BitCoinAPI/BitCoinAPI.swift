//
//  BitCoinAPI.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

class BitCoinAPI {
    
//    func fetchSingleAddressInfo(address: Address, page: Int = 0, completion: @escaping (_ addressInfo: SingleAddressInfo?, _ error: String?)->()) {
//        
//        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockchainInfo.singleAddress + address.address) else {
//            completion(nil, "Error creating endpoint")
//            return
//        }
//        
//        let request = URLRequest(url: endpoint)
//        
//            URLSession.shared.dataTask(with: request) { [unowned self](data, response, error) in
//            
//                do {
//                    guard let data = data else { completion(nil, "data is nill"); return}
//                    
//                    let singleAddressBlockchainInfoResponse = try JSONDecoder().decode(SingleAddressBlockchainInfoResponse.self, from: data)
//                    
//                    guard let b = singleAddressBlockchainInfoResponse.final_balance else { completion(nil, "errorFetchingBalance"); return }
//                    
//                    let balance = b / 100000000
//                    
//                    guard let selfAddress = singleAddressBlockchainInfoResponse.address else { completion(nil, "errorFetchingAddress"); return }
//                    
//                    guard let rawTransactions = singleAddressBlockchainInfoResponse.txs else { completion(nil, "errorFetchingTransactions"); return }
//                    
//                    var transactions = [Transaction]()
//                    
//                    self.latestBlockHeight(completion: { (latestBlockHeight, error) in
//                        guard error != nil else { completion(nil, error); return }
//                        
//                        for rawTransaction in rawTransactions {
//                            
//                            guard let inputs = rawTransaction.inputs else {
//                                continue
//                            }
//                            
//                            var type = TransactionType.receipt
//                            
//                            var totalInputsValue: Decimal = 0
//                            
//                            var receiptAddress = ""
//                            
//                            for input in inputs {
//                                
//                                guard let prev_out = input.prev_out else {
//                                    continue
//                                }
//                                
//                                receiptAddress = prev_out.addr ?? ""
//                                
//                                if prev_out.addr == selfAddress {
//                                    type = TransactionType.send
//                                }
//                                
//                                if let value = prev_out.value {
//                                    totalInputsValue += value
//                                }
//                            }
//                            
//                            guard let outputs = rawTransaction.out else {
//                                continue
//                            }
//                            
//                            var totalOutputsValue: Decimal = 0
//                            var outputsWithoutSelf: Decimal = 0
//                            var outputsWithSelf: Decimal = 0
//                            
//                            var sendAddress = ""
//                            
//                            for output in outputs {
//                                if output.addr != selfAddress {
//                                    outputsWithoutSelf += output.value ?? 0
//                                    sendAddress = output.addr ?? ""
//                                } else {
//                                    outputsWithSelf += output.value ?? 0
//                                }
//                                
//                                totalOutputsValue += output.value ?? 0
//                            }
//                            
//                            let secondAddress: String!
//                            
//                            var value: Decimal = 0
//                            
//                            switch type {
//                            case .receipt:
//                                secondAddress = receiptAddress
//                                value = outputsWithSelf
//                            case .send:
//                                secondAddress = sendAddress
//                                value = outputsWithoutSelf
//                            }
//                            
//                            let fee = totalInputsValue - totalOutputsValue
//                            
//                            guard let t = rawTransaction.time else {
//                                continue
//                            }
//                            
//                            let date = Date(timeIntervalSince1970: t)
//                            
//                            guard let blockHeight = rawTransaction.block_height else {
//                                continue
//                            }
//                            
//                            guard let latestBlockHeight = latestBlockHeight else { completion(nil, "latestBlockHeight is nil"); return }
//                            
//                            let confirmations = latestBlockHeight - blockHeight + 1
//                            
//                            guard let id = rawTransaction.tx_index else {
//                                continue
//                            }
//                            
//                            let transction = Transaction(currency: address.currency,
//                                                         type: type,
//                                                         result: value / 100000000,
//                                                         date: date,
//                                                         address: secondAddress,
//                                                         fee: fee / 100000000,
//                                                         confirmations: confirmations,
//                                                         id: id)
//                            
//                            transactions.append(transction)
//                        }
//                        
//                        completion(SingleAddressInfo.init(transactions: transactions, balance: Balance(value: balance)), nil)
//                    })
//                    
//                } catch let error {
//                    print(error)
//                    completion(nil, "errorFetchingSindleAddressInfo")
//                }
//            }.resume()
//    }
//    
//    private func latestBlockHeight(completion: @escaping (_ blockHeight: Decimal?, _ error: String?)->()) {
//        
//        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockchainInfo.latestBlock) else { completion(nil, "Error creating endpoint"); return }
//        
//        let request = URLRequest(url: endpoint)
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//                do {
//                    
//                    guard let data = data else { completion(nil, "data is nill"); return}
//                    
//                    let latestBlockBlockchainInfoResponse = try JSONDecoder().decode(LatestBlockBlockchainInfoResponse.self, from: data)
//                    
//                    guard let height = latestBlockBlockchainInfoResponse.height else { completion(nil, "errorFetchingLatestBlockHeight"); return }
//                    
//                    completion(height, nil)
//                    
//                } catch let error {
//                    print(error)
//                    completion(nil, "errorFetchingLatestBlockHeight")
//                }
//            }.resume()
//    }
    
    func fetchSingleAddressInfo(address: Address, page: Int = 0, completion: @escaping (_ addressInfo: SingleAddressInfo?, _ error: String?)->()) {
        
        var balance: Decimal? = nil
        var transactions: [Transaction]? = nil
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchAddressBalance(address: address) { (b, error) in
            balance = b
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchTransactionHistory(address: address) { (txs, error) in
            transactions = txs
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let b = balance, let txs = transactions {
                completion(SingleAddressInfo.init(transactions: txs, balance: Balance(value: b)), nil)
            } else {
                completion(nil, "b or txs is nill")
            }
        }
    }
    
    private func fetchAddressBalance(address: Address, completion: @escaping (_ balance: Decimal?, _ error: String?) -> ()) {
        
        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockExplorer.singleAddress + address.address) else {
            completion(nil, "Error creating endpoint")
            return
        }
        
        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do {
                guard let data = data else { completion(nil, "data is nill"); return}
                
                let addressInfo = try JSONDecoder().decode(BlockExplorerAddressInfo.self, from: data)
                
                guard let confirmedBalance = addressInfo.balance else { completion(nil, "confirmedBalance is nill"); return}
                
                guard let unconfirmedBalance = addressInfo.unconfirmedBalance else { completion(nil, "unconfirmedBalance is nill"); return}
                
                completion(confirmedBalance + unconfirmedBalance, nil)
                
            } catch let error {
                print(error)
                completion(nil, "errorFetchingSindleAddressInfo")
            }
            }.resume()
    }
    
    private func fetchTransactionHistory(address: Address, completion: @escaping (_ transactions: [Transaction]?, _ error: String?) -> ()) {

        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockExplorer.historyTransactions + address.address) else {
            completion(nil, "Error creating endpoint")
            return
        }
        
        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do {
                guard let data = data else { completion(nil, "data is nill"); return}
                
                let blockExplorerTransactionHistory = try JSONDecoder().decode(BlockExplorerTransactionHistory.self, from: data)
                
                guard let txs = blockExplorerTransactionHistory.txs else { completion(nil, "txs is nill"); return}
                
                var transactions = [Transaction]()
                
                for t in txs {
                    
                    guard let time = t.time else { completion(nil, "txs date is nill"); return}
                    
                    guard let confirmations = t.confirmations else { completion(nil, "txs confirmations is nill"); return}
                    
                    guard let id = t.txid else { completion(nil, "txs id is nill"); return}
                    
                    guard let inputs = t.vin else {
                        continue
                    }
                    
                    var type = TransactionType.receipt
                    
                    var totalInputsValue: Decimal = 0
                    
                    var receiptAddress = ""
                    
                    for input in inputs {
                        
                        receiptAddress = input.addr ?? ""
                        
                        if receiptAddress == address.address {
                            type = TransactionType.send
                        }
                        
                        if let value = input.valueSat {
                            totalInputsValue += value
                        }
                    }
                    
                    guard let outputs = t.vout else {
                        continue
                    }
                    
                    var totalOutputsValue: Decimal = 0
                    var outputsWithoutSelf: Decimal = 0
                    var outputsWithSelf: Decimal = 0
                    
                    var sendAddress = ""
                    
                    for output in outputs {
                        guard let outputAddreses = output.scriptPubKey?.addresses else { completion(nil, "txs outputAddreses is nill"); return}
                        guard outputAddreses.count > 0 else { completion(nil, "txs outputAddress is nill"); return}
                        let outputAddress = outputAddreses[0]
                        if outputAddress != address.address {
                            
                            guard let outputStringValue = output.value else { completion(nil, "txs outputValue is nill"); return}
                            let outputValue = Decimal(string: outputStringValue) ?? 0
                            outputsWithoutSelf += outputValue * 100000000
                            sendAddress = outputAddress
                        } else {
                            guard let outputStringValue = output.value else { completion(nil, "txs outputValue is nill"); return}
                            let outputValue = Decimal(string: outputStringValue) ?? 0
                            outputsWithSelf += outputValue * 100000000
                        }
                        
                        guard let outputStringValue = output.value else { completion(nil, "txs outputValue is nill"); return}
                        let outputValue = Decimal(string: outputStringValue) ?? 0
                        totalOutputsValue += outputValue * 100000000
                    }
                    
                    let secondAddress: String!
                    
                    var value: Decimal = 0
                    
                    switch type {
                    case .receipt:
                        secondAddress = receiptAddress
                        value = outputsWithSelf
                    case .send:
                        secondAddress = sendAddress
                        value = outputsWithoutSelf
                    }
                    
                    let fee = totalInputsValue - totalOutputsValue
                    
                    let transction = Transaction(currency: address.currency,
                                                 type: type,
                                                 result: value / 100000000,
                                                 date: Date(timeIntervalSince1970: time),
                                                 address: secondAddress,
                                                 fee: fee / 100000000,
                                                 confirmations: confirmations,
                                                 id: id)
                    
                    transactions.append(transction)
                }
                
                completion(transactions, nil)
                
            } catch let error {
                print(error)
                completion(nil, "errorFetchingTransactionHistory")
            }
            }.resume()
    }
    
    func fetchUnspentOutputs(address: Address, completion: @escaping (_ UnspentOutputs: [UnspentOutputBlockchainInfoResponse]?, _ error: String?) -> ()) {
        
        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockchainInfo.unspentOutputs + address.address) else { completion(nil, "Error creating endpoint"); return }
        
        let request = URLRequest(url: endpoint)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
                do {
                    
                    guard let data = data else { completion(nil, "data is nill"); return}
                    
                    let unspentOutputsBlockchainInfoResponse = try JSONDecoder().decode(UnspentOutputsBlockchainInfoResponse.self, from: data)
                    
                    completion(unspentOutputsBlockchainInfoResponse.unspent_outputs, nil)
                    
                } catch let error {
                    print(error)
                    completion(nil, "errorFetchingUnspentOutputs")
                }
            }.resume()
    }
    
    func broadcastTransaction(rawTx: String, completion: @escaping (_ success: Bool) -> ()) {
        let url = URL(string: Constants.BitCoinAPI.Blockcypher.broadcast)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString =
        """
        {"tx":"\(rawTx)"}
        """
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    completion(true)
                    return
                }
            }
            
            completion(false)
            }.resume()
    }
}
