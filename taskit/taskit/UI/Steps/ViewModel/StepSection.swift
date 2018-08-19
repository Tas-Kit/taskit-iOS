//
//  StepSection.swift
//  taskit
//
//  Created by xieran on 2018/8/3.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

class StepSection {
    var backgroundColor: UIColor
    var title: String
    var stepStatus: StatusEnu
    var steps = [StepModel]()
    var height: CGFloat {
        get {
            return 50
        }
    }
    
    init(stepStatus: StatusEnu) {
        self.stepStatus = stepStatus
        
        switch stepStatus {
        case .completed:
            title = LocalizedString("已完成")
            backgroundColor = TaskitColor.stepCompletedSection
        case .skipped:
            title = LocalizedString("跳过")
            backgroundColor = TaskitColor.skipedSection
        case .inProgress:
            title = LocalizedString("进行中")
            backgroundColor = TaskitColor.inProgressSection
        case .readyForReview:
            title = LocalizedString("待审核")
            backgroundColor = TaskitColor.readForReviewSection
        case .new:
            title = LocalizedString("未开始")
            backgroundColor = TaskitColor.stepNewSection
        }
    }
}
