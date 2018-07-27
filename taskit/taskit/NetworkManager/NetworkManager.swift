//
//  NetworkManager.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import Alamofire
import JWT

struct NetworkManager {
    static func request(apiPath: NetworkApiPath,
                        method: HTTPMethod,
                        tokenEncoding: Bool = true,
                        params: Parameters?,
                        success: @escaping (_ code: Int, _ msg: String?, _ value: [String: Any]?) -> Void,
                        failure: @escaping () -> Void) {
        let url = NetworkConfiguration.baseUrl + apiPath.rawValue

        SessionManager.default.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let statusCode = response.response?.statusCode ?? -1
                success(statusCode, value as? String, value as? [String: Any])
            case .failure(_):
                failure()
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
