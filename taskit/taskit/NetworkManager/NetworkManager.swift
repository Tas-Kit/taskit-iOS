//
//  NetworkManager.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkManager {
    typealias SuccessBlock = (_ msg: String?, _ value: [String: Any]) -> Void
    typealias FailureBlock = (_ code: Int?, _ msg: String?, _ value: [String: Any]?) -> Void
    
    static func request(apiPath: NetworkApiPath,
                        method: HTTPMethod,
                        tokenEncoding: Bool = true,
                        params: Parameters?,
                        success: @escaping SuccessBlock,
                        failure: @escaping FailureBlock) {
        request(urlString: apiPath.rawValue,
                  method: method,
                  params: params,
                  success: success,
                  failure: failure)
    }
    
    static func request(urlString: String,
                        method: HTTPMethod,
                        tokenEncoding: Bool = true,
                        params: Parameters?,
                        success: @escaping SuccessBlock,
                        failure: @escaping FailureBlock) {
        let url = NetworkConfiguration.baseUrl + urlString
        
        SessionManager.default.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            guard let rsp = response.response else {
                UIApplication.shared.keyWindow?.makeToast("Network Error")
                failure(nil, nil, nil)
                return
            }
            switch response.result {
            case .success(let value):
                if rsp.statusCode == 200 {
                    success(value as? String, value as? [String: Any] ?? [:])
                } else {
                    if let dic = value as? [String: Any] {
                        dic.handleError({ (errorMsg) in
                            failure(rsp.statusCode, errorMsg, dic)
                        })
                    } else {
                        failure(rsp.statusCode, value as? String, value as? [String: Any])
                    }
                }
            case .failure(_):
                //token expired
                if TokenManager.isExpire {
                    retryAfterRefreshToken(urlString: urlString,
                                           method: method,
                                           params: params,
                                           success: success,
                                           failure: failure)
                    return
                }
                
                UIApplication.shared.keyWindow?.makeToast("Network Error")
                failure(nil, nil, nil)
            }
        }
    }
    
    static func retryAfterRefreshToken(urlString: String,
                                       method: HTTPMethod,
                                       tokenEncoding: Bool = true,
                                       params: Parameters?,
                                       success: @escaping SuccessBlock,
                                       failure: @escaping FailureBlock) {
        guard let username = KeychainTool.value(forKey: .username) as? String,
            let password = KeychainTool.value(forKey: .password) as? String else {
                LoginService.logout()
                return
        }
        
        TokenManager.fetchToken(username: username,
                                password: password,
                                success: {
            request(urlString: urlString,
                    method: method,
                    params: params,
                    success: success,
                    failure: failure)
        }) {
            failure(nil, nil, nil)
            LoginService.logout()
            UIApplication.shared.keyWindow?.makeToast(LocalizedString("refresh token failed"))
        }
    }
}
