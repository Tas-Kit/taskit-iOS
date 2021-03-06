//
//  TokenManager.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import Bugly
import OneSignal
import JWTDecode

struct TokenManager {
    static var config: TokenConfig? {
        
        get {
            do {
                if let token = token{
                    let jwt = try decode(jwt: token)
                    return TokenConfig(JSON: jwt.body)
                }
                else{
                    print("Toekn is nil")
                    return nil
                }
            }
            catch{
                print("error decode jwt")
                return nil
            }
        }
    }
    static var token: String? {
        set {
            KeychainTool.set(newValue, key: .token)
        } get {
            return KeychainTool.value(forKey: .token) as? String
        }
    }
    
    //get JWT token
    static func fetchToken(username: String,
                           password: String,
                           success: @escaping () -> Void,
                           failure: @escaping () -> Void) {
        let url = NetworkConfiguration.baseUrl + NetworkApiPath.getJwt.rawValue
        requestToken(url: url, params: ["username": username, "password": password], success: {
            success()
        }, failure: {
            failure()
        })
    }
    
    //network request
    static func requestToken(url: String,
                        params: [String: String],
                        success: @escaping () -> Void,
                        failure: @escaping () -> Void) {
        SessionManager.default.request(url, method: .post, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let errorMsg = (value as? String) ?? ((value as? [String: Any])?.description ?? "")
                    let statusCode = response.response?.statusCode ?? -1
                    if let headers = response.response?.allHeaderFields as? [String: String] {
                        //set cookie
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: (response.request?.url)!)
                        CookieManager.handleCookies(cookies: cookies)
                        //call back
                        success()
                    } else {
                        failure()
                        Bugly.reportError(NSError(domain: errorMsg, code: statusCode, userInfo: nil))
                    }
                case .failure(let error):
                    failure()
                    UIApplication.shared.keyWindow?.makeToast("Token Error")
                    Bugly.reportError(error)
                }
                
        }
    }
}

extension TokenManager {
    static var isExpire: Bool {
        if let config = TokenManager.config, let expireData = config.expireDate{
            return Date().timeIntervalSince1970 + 10 > expireData.timeIntervalSince1970
        }
        return true
    }
}
