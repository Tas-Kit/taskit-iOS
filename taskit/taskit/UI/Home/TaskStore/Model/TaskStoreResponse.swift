//
//  TaskStoreResponse.swift
//  taskit
//
//  Created by xieran on 2018/8/21.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import ObjectMapper

class TaskStoreResponse: Mappable {
    var task_app_list: [TaskStoreAppModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        task_app_list <- map["task_app_list"]
    }
}

class TaskStoreAppModel: Mappable {
    var app_id: String?
    var name: String?
    var author_id: String?
    var author: TaskAuthor?
    var created_date: String?
    var last_update: String?
    var downloads: Int?
    var status: String?
    var price: Double?
    var description: String?
    var current_task: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        app_id <- map["app_id"]
        name <- map["name"]
        author_id <- map["author_id"]
        author <- map["author"]
        created_date <- map["created_date"]
        last_update <- map["last_update"]
        downloads <- map["downloads"]
        status <- map["status"]
        price <- map["price"]
        description <- map["description"]
        current_task <- map["current_task"]
    }
}

class TaskAuthor: Mappable {
    var uid: String?
    var username: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        uid <- map["uid"]
        username <- map["username"]
    }
}
