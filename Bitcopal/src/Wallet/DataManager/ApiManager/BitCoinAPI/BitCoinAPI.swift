//
//  BitCoinAPI.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

class BitCoinAPI {
    
    func fetchSingleAddressInfo(address: Address, page: Int = 0, completion: @escaping (_ addressInfo: SingleAddressInfo?, _ error: String?)->()) {
        
        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockchainInfo.singleAddress + address.address) else {
            completion(nil, "Error creating endpoint")
            return
        }
        
        let request = URLRequest(url: endpoint)
        
            URLSession.shared.dataTask(with: request) { [unowned self](data, response, error) in
            
                do {
                    guard let data = data else { completion(nil, "data is nill"); return}
                    
                    let singleAddressBlockchainInfoResponse = try JSONDecoder().decode(SingleAddressBlockchainInfoResponse.self, from: data)
                    
                    guard let b = singleAddressBlockchainInfoResponse.final_balance else { completion(nil, "errorFetchingBalance"); return }
                    
                    let balance = b / 100000000
                    
                    guard let selfAddress = singleAddressBlockchainInfoResponse.address else { completion(nil, "errorFetchingAddress"); return }
                    
                    guard let rawTransactions = singleAddressBlockchainInfoResponse.txs else { completion(nil, "errorFetchingTransactions"); return }
                    
                    var transactions = [Transaction]()
                    
                    self.latestBlockHeight(completion: { (latestBlockHeight, error) in
                        if error != nil {
                            completion(nil, error)
                            return
                        }
                        
                        for rawTransaction in rawTransactions {
                            
                            guard let inputs = rawTransaction.inputs else {
                                continue
                            }
                            
                            var type = TransactionType.receipt
                            
                            var totalInputsValue: Decimal = 0
                            
                            var receiptAddress = ""
                            
                            for input in inputs {
                                
                                guard let prev_out = input.prev_out else {
                                    continue
                                }
                                
                                receiptAddress = prev_out.addr ?? ""
                                
                                if prev_out.addr == selfAddress {
                                    type = TransactionType.send
                                }
                                
                                if let value = prev_out.value {
                                    totalInputsValue += value
                                }
                            }
                            
                            guard let outputs = rawTransaction.out else {
                                continue
                            }
                            
                            var totalOutputsValue: Decimal = 0
                            var outputsWithoutSelf: Decimal = 0
                            var outputsWithSelf: Decimal = 0
                            
                            var sendAddress = ""
                            
                            for output in outputs {
                                if output.addr != selfAddress {
                                    outputsWithoutSelf += output.value ?? 0
                                    sendAddress = output.addr ?? ""
                                } else {
                                    outputsWithSelf += output.value ?? 0
                                }
                                
                                totalOutputsValue += output.value ?? 0
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
                            
                            guard let t = rawTransaction.time else {
                                continue
                            }
                            
                            let date = Date(timeIntervalSince1970: t)
                            
                            guard let blockHeight = rawTransaction.block_height else {
                                continue
                            }
                            
                            guard let latestBlockHeight = latestBlockHeight else { completion(nil, "latestBlockHeight is nil"); return }
                            
                            let confirmations = latestBlockHeight - blockHeight + 1
                            
                            guard let id = rawTransaction.tx_index else {
                                continue
                            }
                            
                            let transction = Transaction(currency: address.currency,
                                                         type: type,
                                                         result: value / 100000000,
                                                         date: date,
                                                         address: secondAddress,
                                                         fee: fee / 100000000,
                                                         confirmations: confirmations,
                                                         id: id)
                            
                            transactions.append(transction)
                        }
                        
                        completion(SingleAddressInfo.init(transactions: transactions, balance: Balance(value: balance)), nil)
                    })
                    
                } catch let error {
                    print(error)
                    completion(nil, "errorFetchingSindleAddressInfo")
                }
            }.resume()
    }
    
    private func latestBlockHeight(completion: @escaping (_ blockHeight: Decimal?, _ error: String?)->()) {
        
        guard let endpoint = URL(string: Constants.BitCoinAPI.BlockchainInfo.latestBlock) else { completion(nil, "Error creating endpoint"); return }
        
        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in

                do {
                    
                    guard let data = data else { completion(nil, "data is nill"); return}
                    
                    let latestBlockBlockchainInfoResponse = try JSONDecoder().decode(LatestBlockBlockchainInfoResponse.self, from: data)
                    
                    guard let height = latestBlockBlockchainInfoResponse.height else { completion(nil, "errorFetchingLatestBlockHeight"); return }
                    
                    completion(height, nil)
                    
                } catch let error {
                    print(error)
                    completion(nil, "errorFetchingLatestBlockHeight")
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
    
    func broadcastTransaction(rawTx: String, completion: @escaping (_ success: Bool, _ hash: String?) -> ()) {
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
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, Any>
                            
                            if let tx = json!["tx"] as? Dictionary<String, Any> {
                                
                                if let hash = tx["hash"] as? String {
                                    print(hash)
                                    completion(true, hash)
                                    return
                                }
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            completion(true, nil)
                            return
                        }
                    }

                    completion(true, nil)
                    return
                }
            }
            
            completion(false, nil)
            }.resume()
    }
}
