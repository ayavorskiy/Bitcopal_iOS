//
//  ReceiveViewController.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/29/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit
import IQKeyboardManager

class ReceiveViewController: UIViewController {
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var walletAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setTabBar(hidden: false)
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        let text = receiveAddress()
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    private func generateVisualCode(address: String) -> UIImage? {
        let parameters: [String : Any] = [
            "inputMessage": address.data(using: .utf8)!,
            "inputCorrectionLevel": "L"
        ]
        let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: parameters)
        
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let scaledImage = outputImage.applying(CGAffineTransform(scaleX: 6, y: 6))
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func receiveAddress() -> String {
        guard let address = DataManager.shared.getWalletAddress(type: .bitcoin)?.address else { fatalError() }

        return address
    }

    private func updateUI() {
        qrCodeImageView.image = generateVisualCode(address: receiveAddress())
        walletAddressLabel.text = receiveAddress()
        
        shareButton.dropShadow(color: UIColor.Common.navBarShadow,
                              opacity: 1,
                              offSet: CGSize(width: 3.0, height: 3.0),
                              radius: 4)

    }
    
    func setTabBar(hidden: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let tabBarController = appDelegate.window?.rootViewController as? UITabBarController else {return}
        
        tabBarController.tabBar.isHidden = hidden
    }
}
