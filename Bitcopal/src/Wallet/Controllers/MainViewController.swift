//
//  MainViewController.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/25/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit
import BitcoinKit
import SafariServices

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
    
            cell.currencies = getCurrenies()
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BalanceCollectionViewCell", for: indexPath) as? BalanceCollectionViewCell else {
                fatalError()
            }
            
            if #available(iOS 10.0, *) {
                collectionView.refreshControl?.endRefreshing()
            }
            
            guard let balance = data?.balance.value else { return cell}
            
            let doubleBalance = Double(balance as NSNumber)
          
            cell.balanceLabel.text = String(format: "%.8f", doubleBalance)
            cell.exchangeRateLabel.text = String(format: "~ %.2f USD", doubleBalance * bitcoinExchangeRate)
            cell.currencyLabel.text = getCurrenies().first(where: {$0.isSelected == true})?.title
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionsCollectionViewSection", for: indexPath) as? TransactionsCollectionViewSection else {
                fatalError()
            }
            
            if #available(iOS 10.0, *) {
                collectionView.refreshControl?.endRefreshing()
            }
            
            guard let transactions = data?.transactions else { return cell}
           
            cell.transactions = transactions
            cell.selectionHandler = { (transaction) in
                self.presentTransactionDetails(transaction.id)
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
            let height = UIScreen.main.bounds.height - 64 - 104 - 197 - 49
            
            return CGSize(width: collectionView.bounds.size.width, height: height)
        default:
            return size
        }
    }
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PeerGroupDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var data: SingleAddressInfo? = nil
    var address: Address?
    
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
        
        checkUser()
        userRefreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func userRefreshData() {
        guard let address = self.address else { return }
        
        DataManager.shared.apiManager.getSingleAddressInfo(address: address) { (info, error) in
            DispatchQueue.main.async {
                self.data = info
                self.reloadData()
            }
        }
    }
    
    func reloadData() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl?.endRefreshing()
        }
        
        collectionView.reloadData()
    }
    
    func checkUser() {
        if let address = DataManager.shared.getWalletAddress(type: .bitcoin) {
            self.address = address
        } else {
            guard let viewController = UIStoryboard(name: "Create", bundle: nil).instantiateInitialViewController() else { return }
            present(viewController, animated: false, completion: nil)
        }
    }
    
    func getCurrenies() -> [Currency] {
        let array = [Currency(with: UIImage(named: "im_bitcoin")!, title: "BTС", type: .bitcoin, isSelected: true),
                     Currency(with: UIImage(named: "im_ephir")!, title: "Etherium", type: .etherium),
                     Currency(with: UIImage(named: "im_l")!, title: "Litecoin", type: .litecoin),
                     Currency(with: UIImage(named: "im_bitcostar")!, title: "Bitcostar", type: .bitcostar)]
        
        return array
    }
    
    func presentTransactionDetails(_ transactionId: String) {
        guard let url = URL(string: Constants.BitCoinAPI.Blockchain.transactionDetails + transactionId) else { return }
        
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
}
