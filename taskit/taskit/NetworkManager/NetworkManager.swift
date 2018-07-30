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
    static func request(apiPath: NetworkApiPath,
                        method: HTTPMethod,
                        tokenEncoding: Bool = true,
                        params: Parameters?,
                        success: @escaping (_ msg: String?, _ value: [String: Any]?) -> Void,
                        failure: @escaping (_ code: Int?, _ msg: String?, _ value: [String: Any]?) -> Void) {
        let url = NetworkConfiguration.baseUrl + apiPath.rawValue

        SessionManager.default.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            guard let rsp = response.response else {
                failure(nil, nil, nil)
                return
            }
            
            switch response.result {
            case .success(let value):
                if rsp.statusCode == 200 {
                    success(value as? String, value as? [String: Any])
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
                UIApplication.shared.keyWindow?.makeToast(LocalizedString("网络异常"))
                failure(nil, nil, nil)
            }
        }
    }
}

//extension Dictionary where Key: Encodable, Value: Encodable {
//    func tokenEncoded() -> Dictionary{
//        guard let token = TokenManager.token else {
//            return self
//        }
//        return JWT.encode(claims: self, algorithm: Algorithm.hs256("secret".data(using: .utf8)!))
//    }
//}
