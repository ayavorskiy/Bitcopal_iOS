//
//  SendViewController.swift
//  Wallet
//
//  Created by Костюкевич Илья on 7/5/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SafariServices

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

class SendViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var feeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feeButton: UIButton!
    @IBOutlet weak var feeViewSeparatorView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var feeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberPadView: UIStackView!
    @IBOutlet weak var numberPadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var amoundTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = true
        
        updateUI()
        setupTextFields()
        updateBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setTabBar(hidden: false)
    }
    
    private func updateUI() {
        sendButton.dropShadow(color: UIColor.Common.navBarShadow,
                               opacity: 1,
                               offSet: CGSize(width: 3.0, height: 3.0),
                               radius: 4)
        
        setFeeView(hidden: true)
        setNumberPadView(hidden: true)
    }
    
    func updateBalance() {
        if let address = DataManager.shared.getWalletAddress(type: .bitcoin) {
            DataManager.shared.apiManager.getSingleAddressInfo(address: address) { (info, error) in
                DispatchQueue.main.async {
                    guard let balance = info?.balance.value else { return }

                    let doubleBalance = Double(balance as NSNumber)
                    
                    self.balanceLabel.text = "Balance: \(doubleBalance) BTC"
                }
            }
        }
    }
    
    private func setupTextFields() {
        addressTextField.delegate = self
        amoundTextField.delegate = self
        
        let scanButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        scanButton.setTitle("Scan", for: .normal)
        scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        scanButton.setTitleColor(.black, for: .normal)
        scanButton.layer.borderColor = UIColor(rgbColorCodeRed: 214, green: 214, blue: 214, alpha: 1).cgColor
        scanButton.layer.borderWidth = 1
        scanButton.layer.cornerRadius = 2
        scanButton.dropShadow(color: UIColor.Common.navBarShadow,
                              opacity: 1,
                              offSet: CGSize(width: 3.0, height: 3.0),
                              radius: 4)
        
        scanButton.addTarget(self, action: #selector(openBarCodeReader), for: .touchUpInside)
        
        addressTextField.rightView = scanButton
        addressTextField.rightViewMode = .always
        
        amoundTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        if var address = DataManager.shared.getWalletAddress(type: .bitcoin) {
            guard let toAdress = self.addressTextField.text, !toAdress.isEmpty else {
                self.showAlert(title: "Validation error", message: "Address can't be empty!")
                return
            }
            
            guard let amount = self.calculateAmount(text: self.amoundTextField.text) else {
                self.showAlert(title: "Validation error", message: "Amount can't be empty!")
                return
            }
            
            guard let fee = self.calculateFee(text: self.amoundTextField.text) else {
                self.showAlert(title: "Validation error", message: "Fee can't be empty!")
                return
            }
            
            DataManager.shared.apiManager.getSingleAddressInfo(address: address) { (info, error) in
                if let balance = info?.balance.value {
                    address.count = balance
                    
                    guard let balance = address.count else {
                        self.showAlert(title: "Validation error", message: "You don't have enough coins")
                        return
                    }
                    
                    if (fee + amount + 0.00000547) > balance {
                        self.showAlert(title: "Validation error", message: "You don't have enough coins")
                    }
                    
                    DataManager.shared.sendTransaction(fromAddress: address, toAddress: toAdress, amount: amount, fee: fee) { (send) in
                        DispatchQueue.main.async {
                            if send {
                                self.showAlert(title: nil, message: "Your transaction was sent to Blockchain and now in unconfirmed status till Bitcoin miners entered this transaction into a block of transaction on the Blockchain.")
                            } else {
                                self.showAlert(title: "Sending error", message: "Something went wrong")
                            }
                        }
                    }
                }
            }
        } else {
            self.showAlert(title: "Validation error", message: "Address can't be empty!")
        }
    }
    
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(nil)
    }
    
    func dismiss(_ completion: (() -> Void)?) {
        dismiss(animated: false) {
            completion?()
        }
    }
    
    @IBAction func feeButtonPressed(_ sender: Any) {
        setFeeView(hidden: !feeView.isHidden)
    }
    
    @IBAction func segmentedControlChangeValue(_ sender: UISegmentedControl) {
        if let text = amoundTextField.text {
            setupFeeButtonTitle(text: text)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            setupFeeButtonTitle(text: text)
        }
    }
    
    func setupFeeButtonTitle(text: String) {
        if let fee = calculateFee(text: text) {
            feeButton.setTitle("Fee: \(String(format: "%.8f", Double(fee as NSNumber))) BTC", for: .normal)
        } else {
            feeButton.setTitle("Fee: \(0) BTC", for: .normal)
        }
    }
    
    func calculateFee(text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        
        guard let fee = Double(text.replacingOccurrences(of: ",", with: ".")) else { return 0}
        
        if feeSegmentedControl.selectedSegmentIndex == 1 {
            return 10/100000000
        }

        return Decimal(20*fee/100)
    }
    
    func calculateAmount(text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        guard let amount = Double(text.replacingOccurrences(of: ",", with: ".")) else { return 0}
        
        return Decimal(amount)
    }
    
    func setFeeView(hidden: Bool) {
        feeView.isHidden = hidden
        feeViewSeparatorView.isHidden = hidden
        feeViewHeightConstraint.constant = hidden ? 0 : 50
    }
    
    func setNumberPadView(hidden: Bool) {
        numberPadView.isHidden = hidden
        numberPadViewHeightConstraint.constant = hidden ? 0 : 144
    }
    
    func openBarCodeReader() {
        guard let readerVC = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "BarCodeReaderViewController") as? BarCodeReaderViewController else {
            fatalError()
        }
        
        readerVC.completition = { (address) in
            self.addressTextField.text = address
            readerVC.dismiss(animated: true, completion: nil)
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    private func setTabBar(hidden: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let tabBarController = appDelegate.window?.rootViewController as? UITabBarController else {return}
        
        tabBarController.tabBar.isHidden = hidden
    }
}
