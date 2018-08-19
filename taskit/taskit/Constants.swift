//
//  Constants.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

struct Constants {
    static let verifyCodeLength = 6
    
    static let navigationTitleFont = UIFont.systemFont(ofSize: 18)
}

extension Notification.Name {
    static let kDidGetSteps = Notification.Name.init("kDidGetSteps")
    static let kUpdateNotificationBadge = Notification.Name.init("kUpdateNotificationBadge")
    static let kUpdateStepTabbarSelectedIndex = Notification.Name.init("kUpdateStepTabbarSelectedIndex")
    static let kHomeRefresh = Notification.Name.init("kHomeRefresh")
}

enum StatusEnu: String {
    case new = "n"
    case inProgress = "ip"
    case readyForReview = "rr"
    case completed = "c"
    case skipped = "s"
    
    var statusString: String {
        switch self {
        case .new:
            return LocalizedString("未开始")
        case .inProgress:
            return LocalizedString("进行中")
        case .readyForReview:
            return LocalizedString("待审核")
        case .completed:
            return LocalizedString("已完成")
        case .skipped:
            return LocalizedString("跳过")
        }
    }
    
    var priority: Int {
        switch self {
        case .new:
            return 5
        case .inProgress:
            return 4
        case .readyForReview:
            return 3
        case .completed:
            return 2
        case .skipped:
            return 1
        default:
            return 0
        }
    }
}

enum NodeType: String {
    case n
    case s
    case e
}

enum Acceptance: String {
    case accept  = "a"
    case reject  = "r"
    case waiting = "w"
}

enum SuperRole: Int {
    case owner = 10
    case admin = 5
    case standard = 0
    
    var descString: String {
        switch self {
        case .owner:
            return LocalizedString("所有者")
        case .admin:
            return LocalizedString("管理员")
        case .standard:
            return LocalizedString("普通")
        }
    }
}

enum RoleType {
    case superRole
    case role
}

enum TimeUnit: String {
    case s
    case m
    case h
    case d
    case w
    case M
    case y
    
    var descrition: String {
        switch self {
        case .s:
            return LocalizedString("秒")
        case .m:
            return LocalizedString("分")
        case .h:
            return LocalizedString("时")
        case .d:
            return LocalizedString("天")
        case .w:
            return LocalizedString("周")
        case .M:
            return LocalizedString("月")
        case .y:
            return LocalizedString("年")
        }
    }
}
