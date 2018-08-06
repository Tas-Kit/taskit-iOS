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
}

extension Notification.Name {
    static let kDidGetSteps = Notification.Name.init("kDidGetSteps")
}

enum StepStatus: String {
    case new = "n"
    case inProgress = "ip"
    case readyForReview = "rr"
    case completed = "c"
    case skipped = "s"
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
