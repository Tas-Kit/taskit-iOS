//
//  TodoListResponse.swift
//  taskit
//
//  Created by xieran on 2018/8/21.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import ObjectMapper

class TodoListResponse: Mappable {
    var list: [TodoListUnit]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        list <- map["todo_list"]
    }
}

class TodoListUnit: Mappable {
    var step: StepModel?
    var task: TaskResponse?
    var has_task: HasTaskResponse?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        step <- map["step"]
        task <- map["task"]
        has_task <- map["has_task"]
    }
}

