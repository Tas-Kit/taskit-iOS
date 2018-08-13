//
//  ApiPath.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation


enum NetworkApiPath: String {
    //exempt
    case getJwt        = "api/v1/userservice/exempt/get_jwt/"
    case login         = "api/v1/userservice/exempt/login/"
    case resetPassword = "api/v1/userservice/exempt/set_password/"
    case verifyCode    = "api/v1/userservice/exempt/reset_password/"
    case regist        = "api/v1/userservice/exempt/signup/"
    //user
    case userInfo      = "api/v1/userservice/userinfo/"
    //task
    case task          = "api/v1/taskservice/task/"
    case graph         = "api/v1/taskservice/task/graph/"
    //invitation
    case invitaiton    = "api/v1/taskservice/task/invitation/"
    case respond       = "api/v1/taskservice/task/invitation/respond/"
    case changeRole    = "api/v1/taskservice/task/invitation/change/"
}
