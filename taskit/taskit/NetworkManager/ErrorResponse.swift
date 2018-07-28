//
//  ErrorResponse.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import ObjectMapper
class ErrorResponse: Mappable {
    var errorMsg: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        errorMsg <- map["non_field_errors"]
    }
}
