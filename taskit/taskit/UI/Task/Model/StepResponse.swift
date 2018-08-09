//
//  StepResponse.swift
//  taskit
//
//  Created by xieran on 2018/8/6.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import ObjectMapper

class StepResponse: Mappable {
    var taskInfo: TaskResponse?
    var steps: [StepModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        taskInfo <- map["task_info"]
        steps <- map["nodes"]
    }
}

class StepModel: Mappable {
    var status: StepStatus?
    var pos_x: CGFloat?
    var pos_y: CGFloat?
    var name: String?
    var reviewers: [String]?
    var assignees: [String]?
    var node_type: NodeType?
    var deadline: String?
    var expected_effort_unit: TimeUnit?
    var sid: String?
    var is_optional: Bool?
    var expected_effort_num: Double?
    var id: Int?
    var description: String?
        
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status      <- map["status"]
        pos_x       <- map["pos_x"]
        pos_y       <- map["pos_y"]
        name        <- map["name"]
        reviewers   <- map["reviewers"]
        assignees   <- map["assignees"]
        node_type   <- map["node_type"]
        deadline    <- map["deadline"]
        sid         <- map["sid"]
        is_optional <- map["is_optional"]
        id          <- map["id"]
        description <- map["description"]
        expected_effort_unit <- map["expected_effort_unit"]
        expected_effort_num  <- map["expected_effort_num"]
    }
}
