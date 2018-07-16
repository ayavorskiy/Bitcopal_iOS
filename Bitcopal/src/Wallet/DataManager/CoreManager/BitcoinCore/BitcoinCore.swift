//
//  BitcoinCore.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 11.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation
import BitcoinKit
import CryptoSwift

class BitCoinCore {
    
    func createWallet(completion: (_ address: Address)->()) {
        
        let mnemonic = generateMnemonic()
        let seed = Mnemonic.seed(mnemonic: mnemonic)
        let wallet = HDWallet(seed: seed, network: .mainnet)
        let key = Base58.encode(seed)//wallet.privateKey.raw
        
        completion(Address(address: wallet.address, currency: .bitcoin, mnemonic: mnemonic, privateKey: key, seed: seed))
    }
    
    private func generateMnemonic() -> [String] {
        if let mnemonic = try? Mnemonic.generate() {
            return mnemonic
        } else {
            return generateMnemonic()
        }
    }
    
    //MARK: amount must be = fromAddress.fromAddress + fee or < fromAddress.fromAddress + fee + 547
    func generateTransaction(fromAddress: Address, toAddress: String, amount: Decimal, fee: Decimal, unspentOutputs: [UnspentOutputBlockchainInfoResponse], completion: (_ rawTx: String?, _ error: String?) ->()) {
        
        guard let p = fromAddress.privateKey else {completion(nil, "wrong address/privateKey"); return}
        
        let wallet = HDWallet(seed: Base58.decode(p), network: .mainnet)
        
        let fromPublicKey = wallet.publicKey
        print(fromPublicKey.toAddress())
        let fromPubKeyHash = Crypto.sha256ripemd160(fromPublicKey.raw)
        let toPubKeyHash = Base58.decode(toAddress).dropFirst().dropLast(4)
        
        let lockingScript1 = Script.buildPublicKeyHashOut(pubKeyHash: toPubKeyHash)
        let lockingScript2 = Script.buildPublicKeyHashOut(pubKeyHash: fromPubKeyHash)

        let amount = NSDecimalNumber(decimal: amount * 100000000).int64Value
        guard let c = fromAddress.count else {completion(nil, "count is nill"); return}
        let balance = NSDecimalNumber(decimal:     c * 100000000).int64Value
        let fee = NSDecimalNumber(decimal:       fee * 100000000).int64Value
   
        let sending = TransactionOutput(value: amount, scriptLength: VarInt(lockingScript1.count), lockingScript: lockingScript1)
  
        var outputMinValue = amount + fee
        var uOutputs = unspentOutputs.sorted(by: { $0.value < $1.value })
        var inputs = [UnspentOutputBlockchainInfoResponse]()
        
        if outputMinValue > balance  {
            completion(nil, "outputMinValue > balance"); return
        } else if balance - outputMinValue < 547 {
            completion(nil, "payback is to small"); return
        }
        
        var txOutputs = [TransactionOutput]()
        
        while true {
            
            var added = false
            for (index, output) in uOutputs.enumerated() {
                if NSDecimalNumber(decimal: output.value).int64Value >= outputMinValue {
                    inputs.append(output)
                    outputMinValue -= NSDecimalNumber(decimal: output.value).int64Value
                    uOutputs.remove(at: index)
                    added = true
                    break
                }
            }
            if !added {
                inputs.append(uOutputs[uOutputs.endIndex - 1])
                outputMinValue -= NSDecimalNumber(decimal: uOutputs[uOutputs.endIndex - 1].value).int64Value
                uOutputs.remove(at: uOutputs.endIndex - 1)
            }
            
            if outputMinValue == 0 {
                txOutputs = [sending]
                break
            } else if outputMinValue < 547 {
                let payback = TransactionOutput(value: -outputMinValue, scriptLength: VarInt(lockingScript2.count), lockingScript: lockingScript2)
                txOutputs = [sending, payback]
                break
            }
        }
        
        var signedInputs = [TransactionInput]()
        
        for (i, _) in inputs.enumerated() {
            
            var transactionInputsForSign = [TransactionInput]()
            
            for (j, tI) in inputs.enumerated() {
                
                let outpoint = TransactionOutPoint(hash: Data(hex: tI.tx_hash_big_endian), index: UInt32(tI.tx_output_n))
                
                let scriptData = i == j ? Data(hex: tI.script) : Data()
                let input = TransactionInput(previousOutput: outpoint, scriptLength: VarInt(scriptData.count), signatureScript: scriptData, sequence: UInt32.max)
                transactionInputsForSign.append(input)
                
            }
            
            let _tx = BitcoinKit.Transaction(version: 1, txInCount: VarInt(transactionInputsForSign.count), inputs: transactionInputsForSign, txOutCount: 2, outputs: txOutputs, lockTime: 0)
            
            var _txBytes = _tx.serialized().bytes
            
            _txBytes.append(contentsOf: UInt32(Signature.SIGHASH_ALL).littleEndian.asByteArray)
            
            let _txHash = Crypto.sha256sha256(Data(bytes: _txBytes))
            
            let signature = try! Crypto.sign(_txHash, privateKey: PrivateKey(data: wallet.privateKey.raw, network: .mainnet))
            
            var bytesForUnlockingSignature = [UInt8(signature.count + 1)]
            bytesForUnlockingSignature.append(contentsOf: signature)
            bytesForUnlockingSignature.append(Signature.SIGHASH_ALL)
            bytesForUnlockingSignature.append(UInt8(fromPublicKey.raw.count))
            bytesForUnlockingSignature.append(contentsOf: fromPublicKey.raw)
            let unlockingScript: Data =  Data(bytes: bytesForUnlockingSignature)
            
            let input = TransactionInput(previousOutput: transactionInputsForSign[i].previousOutput, scriptLength: VarInt(unlockingScript.count), signatureScript: unlockingScript, sequence: UInt32.max)
            
            signedInputs.append(input)
            
        }
        
        let transaction = BitcoinKit.Transaction(version: 1, txInCount: VarInt(signedInputs.count), inputs: signedInputs, txOutCount: 2, outputs: txOutputs, lockTime: 0)
        
        
        completion(transaction.serialized().toHexString(), nil)
    }
    
}
