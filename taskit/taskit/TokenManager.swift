//
//  TokenManager.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import JWT

struct TokenManager {
    static var config: TokenConfig?
    static var token: String? {
        set {
            KeychainTool.set(newValue, key: .token)
            parseTokenConfig()
        } get {
            return KeychainTool.value(forKey: .token) as? String
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
        
        NetworkManager.request(apiPath: .getJwt, method: .post, params: ["username": username, "password": password], success: { (msg, dic) in
            let response = JwtResponse(JSON: dic ?? [:])
            if let _token = response?.token { //success
                TokenManager.token = _token
                success()
            } else { //falied
                failure()
            }
        }) { (_, _, _) in
            failure()
        }
    }
    
    private static let seperator = "."
    private static func parseTokenConfig() {
        guard let components = token?.components(separatedBy: seperator), components.count >= 3, let decodedString = components[1].base64Decoded else {
            return
        }
        
        self.config = TokenConfig(JSONString: decodedString)
    }
}

extension TokenManager {
    static func refreshToken() {
        NetworkManager.request(apiPath: .refreshJwt, method: .post, params: ["token": TokenManager.token ?? ""], success: { (msg, data) in
            
        }) { (_, _, _) in
            
        }
    }
}
