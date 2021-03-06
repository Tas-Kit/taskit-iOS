//
//  TokenConfig.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import ObjectMapper

class TokenConfig: Mappable {
    var expireTs: Int?
    var uid: String?
    var email: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        expireTs <- map["exp"]
        uid <- map["user_id"]
        email <- map["email"]
    }
    
    var expireDate: Date? {
        return Date.init(timeIntervalSince1970: TimeInterval(expireTs ?? 0))
    }
}
