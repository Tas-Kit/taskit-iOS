//
//  TaskResponse.swift
//  taskit
//
//  Created by xieran on 2018/8/1.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import ObjectMapper

enum TaskStatus: String {
    case notStart = "n"
    case inProgress = "ip"
}

class TaskModel: Mappable {
    var task: TaskResponse?
    var hasTask: HasTaskResponse?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        task <- map["task"]
        hasTask <- map["has_task"]
    }
    
    var isDownloaded = false
}

class TaskResponse: Mappable {
    var status: StatusEnu?
    var description: String?
    var roles: [String]?
    var deadline: String?
    var expected_effort_unit: TimeUnit?
    var tid: String?
    var expected_effort_num: CGFloat?
    var id: Int?
    var name: String?
    var origin: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        description <- map["description"]
        roles <- map["roles"]
        deadline <- map["deadline"]
        expected_effort_unit <- map["expected_effort_unit"]
        tid <- map["tid"]
        expected_effort_num <- map["expected_effort_num"]
        id <- map["id"]
        name <- map["name"]
        origin <- map["origin"]
    }
}

class HasTaskResponse: Mappable {
    var acceptance: Acceptance?
    var role: String?
    var id: Int?
    var super_role: SuperRole?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        acceptance <- map["acceptance"]
        role <- map["role"]
        id <- map["id"]
        super_role <- map["super_role"]
    }
}
