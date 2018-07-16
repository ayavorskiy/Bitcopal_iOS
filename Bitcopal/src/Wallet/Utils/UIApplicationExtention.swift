//
//  UIApplicationDelegate.swift
//  Shafa
//
//  Created by Костюкевич Илья on 30.01.2018.
//  Copyright © 2018 evo.company. All rights reserved.
//

import UIKit

extension UIApplication {
//    func getAppDelegate() -> AppDelegate? {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return nil
//        }
//        
//        return appDelegate
//    }
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        
        return nil
    }
}
