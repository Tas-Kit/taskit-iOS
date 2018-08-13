//
//  KeychainTool.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import KeychainAccess

struct KeychainTool {
    enum KeychainStoreKey: String {
        case token
        case username
        case password
        case uid
    }
    
    static let keychain = Keychain(accessGroup: "Taskit")
    static var keychainCache = [String: String]()

    static func set(_ value: String?, key: KeychainStoreKey) {
        guard let noneNilValue = value else {
            return
        }
        try? keychain.set(noneNilValue, key: key.rawValue)
        keychainCache[key.rawValue] = noneNilValue
    }
    
    static func value(forKey key: KeychainStoreKey) -> Any? {
        if let value = keychainCache[key.rawValue] {
            return value
        } else if let value = try? keychain.getString(key.rawValue) {
            keychainCache[key.rawValue] = value
            return value
        } else {
            return nil
        }
    }
}
