//
//  SuperRoleManager.swift
//  taskit
//
//  Created by xieran on 2018/8/13.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

class SuperRoleManager {
    static func superRole(of responseModel: StepResponse?) -> SuperRole? {
        for user in responseModel?.users ?? [] where user.basic?.uid == TokenManager.config?.uid {
            return user.has_task?.super_role
        }
        return nil
    }
    
    static func changeSuperRole(of responseModel: StepResponse?, superRole: SuperRole) {
        for user in responseModel?.users ?? [] where user.basic?.uid == TokenManager.config?.uid {
            user.has_task?.super_role = superRole
        }
    }
}
