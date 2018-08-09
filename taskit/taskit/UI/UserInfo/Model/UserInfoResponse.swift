//
//  UserInfoResponse.swift
//  taskit
//
//  Created by xieran on 2018/8/7.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import ObjectMapper

class UserInfoResponse: Mappable {
    var email: String?
    var username: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        username <- map["username"]
    }
}
