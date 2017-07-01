//
//  KeyManager.swift
//  CollectionView3
//
//  Created by ayako_sayama on 2017-06-30.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation

struct KeyManager {
    private let keyFilePath = Bundle.main.path(forResource: "APIKey", ofType: "plist")
    
    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }
    
    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
