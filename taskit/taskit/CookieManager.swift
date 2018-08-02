//
//  CookieManager.swift
//  taskit
//
//  Created by xieran on 2018/8/1.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

struct CookieManager {
    static func setup() {
        SessionManager.default.session.configuration.httpShouldSetCookies = true

        if let cookieArray = UserDefaults.standard.array(forKey: "kCookies") {
            for cookieData in cookieArray {
                if let dict = cookieData as? [HTTPCookiePropertyKey : Any] {
                    if let cookie = HTTPCookie.init(properties : dict) {
                        SessionManager.default.session.configuration.httpCookieStorage?.setCookie(cookie)
                    }
                }
            }
        }
        
    }
    
    static func handleCookies(cookies: [HTTPCookie]) {
        var array = [[HTTPCookiePropertyKey : Any]]()
        for cookie in cookies where cookie.properties != nil {
            HTTPCookieStorage.shared.setCookie(cookie)
            array.append(cookie.properties!)
        }
        UserDefaults.standard.set(array, forKey: "kCookies")
        UserDefaults.standard.synchronize()
    }
}
