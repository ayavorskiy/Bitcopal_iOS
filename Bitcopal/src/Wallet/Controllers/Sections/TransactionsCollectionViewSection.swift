//
//  TransactionsCollectionViewSection.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/25/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

class TransactionsCollectionViewSection: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectionHandler: ((_ transaction: Transaction) -> Void)?
    
    var transactions = [Transaction]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.dropShadow(color: UIColor.Common.navBarShadow,
                                  opacity: 1,
                                  offSet: CGSize(width: 3, height: 6.0),
                                  radius: 16)
        
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionCollectionViewCell", for: indexPath) as? TransactionCollectionViewCell else {
            fatalError()
        }

        let transaction = transactions[indexPath.row]
        
        let resultBalance = Double(transaction.result as NSNumber)
        
        cell.imageView.image = transaction.type == .receipt ? UIImage(named: "arrow_down") : UIImage(named: "arrow_up")
        cell.addressLabel.text = transaction.address
        cell.amauntLabel.text = (transaction.type == .receipt ? "+" : "-") + String(format: "%.8f", resultBalance) + " BTC"
        cell.amaountUSDLabel.text = String(format: "~ %.2f USD", resultBalance * bitcoinExchangeRate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: transaction.date)

        cell.dateLabel.text = dateString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 78)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionHandler?(transactions[indexPath.row])
    }
}
