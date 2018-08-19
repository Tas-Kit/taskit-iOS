//
//  RoleManager.swift
//  taskit
//
//  Created by xieran on 2018/8/17.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

struct RoleManager {
    static func myRole(of responseModel: StepResponse?) -> String? {
        for user in responseModel?.users ?? [] where user.basic?.uid == TokenManager.config?.uid {
            return user.has_task?.role
        }
        return nil
    }
}
