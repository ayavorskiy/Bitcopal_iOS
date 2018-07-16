//
//  MainNavigationController.swift
//  Wallet
//
//  Created by Костюкевич Илья on 6/26/18.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadow()
        removeLine()
    }

    func addShadow() {
        navigationBar.dropShadow(color: UIColor.Common.navBarShadow,
                                 opacity: 0.7,
                                 offSet: CGSize(width: 3.0, height: 3.0),
                                 radius: 4)
    }
    
    func removeShadow() {
        navigationBar.dropShadow(color: .white,
                                 opacity: 0.0,
                                 offSet: CGSize.zero,
                                 radius: 0)
    }

    func removeLine() {
        navigationBar.barTintColor = UIColor.Common.main
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
