//
//  DMApiExtension.swift
//  Wallet
//
//  Created by Oleksii Shulzhenko on 12.07.2018.
//  Copyright © 2018 Ilya Kostyukevich. All rights reserved.
//

import Foundation

extension DataManager {
    
    func getSingleAddressInfo(address: Address, completion: @escaping (_ singleAddressInfo: SingleAddressInfo?, _ error: String?) ->()) {
        apiManager.getSingleAddressInfo(address: address, completion: completion)
    }
    
}
