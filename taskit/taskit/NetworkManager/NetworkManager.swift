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
    static func request(apiPath: NetworkApiPath, method: HTTPMethod, params: Parameters?) {
        let url = NetworkConfiguration.baseUrl + apiPath.rawValue
        
        SessionManager.default.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                break
            case .failure(_):
                break
            }
        }
    }
}
