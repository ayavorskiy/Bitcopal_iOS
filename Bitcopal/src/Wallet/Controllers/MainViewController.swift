//
//  MainViewController.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/25/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit
import BitcoinKit

extension MainViewController {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrenciesCollectionViewSection", for: indexPath) as? CurrenciesCollectionViewSection else {
                fatalError()
            }
    
            cell.currencies = blockChainService.getCurrenies()
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BalanceCollectionViewCell", for: indexPath) as? BalanceCollectionViewCell else {
                fatalError()
            }
            
            blockChainService.checkBalance { (balance) in
                DispatchQueue.main.async {
                    if #available(iOS 10.0, *) {
                        collectionView.refreshControl?.endRefreshing()
                    }
                    cell.balanceLabel.text = "\(balance)"
                    cell.exchangeRateLabel.text = String(format: "~ %.1f USD", balance * bitcoinExchangeRate)
                }
            }
            
//            cell.balanceLabel.text = "\(blockChainService.getBalance())"
            cell.currencyLabel.text = blockChainService.getCurrenies().first(where: {$0.isSelected == true})?.title
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionsCollectionViewSection", for: indexPath) as? TransactionsCollectionViewSection else {
                fatalError()
            }
            
            blockChainService.checkTransactions { (transactions) in
                DispatchQueue.main.async {
                    if #available(iOS 10.0, *) {
                        collectionView.refreshControl?.endRefreshing()
                    }
                    cell.transactions = transactions
                }
            }
            
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.zero
        
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.bounds.size.width, height: 104)
        case 1:
            return CGSize(width: collectionView.bounds.size.width, height: 197)
        case 2:
            let height = UIScreen.main.bounds.height - 64 - 104 - 197
            
            return CGSize(width: collectionView.bounds.size.width, height: height)
        default:
            return size
        }
    }
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PeerGroupDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let blockChainService = BlockChainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(userRefreshData), for: .valueChanged)
            
            collectionView.refreshControl = refreshControl
        }
        
        checkUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func userRefreshData() {
        collectionView.reloadData()
    }
    
    func reloadData() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl?.endRefreshing()
        }
        
        collectionView.reloadData()
    }
    
    func checkUser() {
        if DataManager.shared.getWalletAddress(type: .bitcoin) == nil {
            guard let viewController = UIStoryboard(name: "Create", bundle: nil).instantiateInitialViewController() else { return }
            present(viewController, animated: false, completion: nil)
        }
    }
}
