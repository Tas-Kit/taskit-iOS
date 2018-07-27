//
//  TokenManager.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

struct TokenManager {
    static var token: String? {
        set {
            KeychainTool.store(newValue, key: .token)
        } get {
            return KeychainTool.value(forKey: .token)
        }
    }
    
    static func fetchToken(username: String,
                           password: String,
                           success: @escaping () -> Void,
                           failure: @escaping () -> Void) {
        guard token == nil else {
            success()
            return
        }
        
        NetworkManager.request(apiPath: .getJwt, method: .post, params: ["username": username, "password": password], success: { (code, msg, dic) in
            
            let response = JwtResponse(JSON: dic ?? [:])
            if let _token = response?.token { //success
                TokenManager.token = _token
                success()
            } else { //falied
                failure()
            }
        }, failure: {
            failure()
        })
    }
}
