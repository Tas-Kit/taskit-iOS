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
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        expireTs <- map["exp"]
    }
    
    var expireDate: Date? {
        return Date.init(timeIntervalSince1970: TimeInterval(expireTs ?? 0))
    }
}
