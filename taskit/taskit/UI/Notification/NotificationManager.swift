//
//  NotificationManager.swift
//  taskit
//
//  Created by xieran on 2018/8/14.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

struct NotificationManager {
    static var notifications = [TaskModel]()
    
    static func fetchNotifications(success: (() -> Void)? = nil,
                                   failure: (() -> Void)? = nil) {
        NetworkManager.request(apiPath: .task, method: .get, params: nil, success: { (msg, dic) in
            notifications.removeAll()
            for (_, value) in dic {
                if let dic = value as? [String: Any], let model = TaskModel(JSON: dic), model.hasTask?.acceptance == .waiting {
                    notifications.append(model)
                }
            }
            success?()
        }) { (code, msg, dic) in
            failure?()
        }
    }
}
