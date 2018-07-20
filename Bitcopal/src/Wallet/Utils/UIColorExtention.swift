//
//  ShafaColors.swift
//  Shafa
//
//  Created by Костюкевич Илья on 29.01.2018.
//  Copyright © 2018 evo.company. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    struct Common {
        static let main = UIColor(rgbColorCodeRed: 242, green: 199, blue: 102, alpha: 1)
        static let navBarShadow = UIColor(rgbColorCodeRed: 24, green: 152, blue: 111, alpha: 0.9)
    }

    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
        let redPart: CGFloat = CGFloat(red) / 255
        let greenPart: CGFloat = CGFloat(green) / 255
        let bluePart: CGFloat = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
    }
    
    func colorFrom(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return .gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
