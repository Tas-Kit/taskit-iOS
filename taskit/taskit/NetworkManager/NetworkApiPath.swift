//
//  ApiPath.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation


enum NetworkApiPath: String {
    case getJwt        = "api/v1/userservice/exempt/get_jwt/"
    case refreshJwt    = "api/v1/userservice/refresh_jwt/"
    case login         = "api/v1/userservice/exempt/login/"
    case resetPassword = "api/v1/userservice/exempt/set_password/"
    case verifyCode    = "api/v1/userservice/exempt/reset_password/"
    case regist        = "api/v1/userservice/exempt/signup/"
}
