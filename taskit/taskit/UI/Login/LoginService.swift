//
//  LoginService.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

typealias LoginSuccess = () -> Void
typealias LoginFailed = (_ reason: String?) -> Void

struct LoginService {
    static var isLogin: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
            UserDefaults.standard.synchronize()
        } get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
    }
    
    static func login(username: String,
                      password: String,
                      success: @escaping LoginSuccess,
                      failed: @escaping LoginFailed) {
        TokenManager.fetchToken(username: username,
                                password: password,
                                success: {
            loginRequest(username, password, success, failed)
        }) {
            failed(nil)
        }
    }
    
    private static func loginRequest(_ username: String,
                             _ password: String,
                             _ success: @escaping LoginSuccess,
                             _ failed: @escaping LoginFailed) {
        NetworkManager.request(apiPath: .login, method: .post, params: ["username": username, "password": password], success: { (msg, dic) in
            //callback
            success()
            //save username in Keychain
            KeychainTool.set(username, key: .username)
            KeychainTool.set(password, key: .password)

            isLogin = true

        }) { (code, msg, dic) in
            if let errorResponse = ErrorResponse(JSON: dic ?? [:]), let reason =  errorResponse.errorMsg {
                failed(reason)
            } else {
                failed(nil)
            }
        }
    }
}
