//
//  Stepself.swift
//  taskit
//
//  Created by xieran on 2018/8/18.
//  Copyright © 2018 Snow. All rights reserved.
//

import UIKit

class StepTriggerButton: UIButton {
    var indexPath: IndexPath?

    func config(step: StepModel?, myRole: String?, indexPath: IndexPath? = nil) {
        self.indexPath = indexPath
        
        if let step = step, let status = step.status {
            switch status {
            case .inProgress:
                let isAssigneesEmpty = step.assignees?.isEmpty ?? true
                let isReviewersEmpty = (step.reviewers?.isEmpty ?? true)
                if isReviewersEmpty {
                    self.setTitle(LocalizedString("完成"), for: .normal)
                } else {
                    self.setTitle(LocalizedString("提交"), for: .normal)
                }
                
                if !isAssigneesEmpty, step.assignees?.contains(myRole ?? "") == false {
                    self.isEnabled = false
                    self.backgroundColor = .lightGray
                } else {
                    self.isEnabled = true
                    self.backgroundColor = TaskitColor.button
                }
            case .readyForReview:
                self.setTitle(LocalizedString("完成"), for: .normal)
                self.setTitle(LocalizedString("完成"), for: .disabled)
                let isReviewersEmpty = (step.reviewers?.isEmpty ?? true)
                if !isReviewersEmpty, step.reviewers?.contains(myRole ?? "") == false {
                    self.isEnabled = false
                    self.backgroundColor = .lightGray
                } else {
                    self.isEnabled = true
                    self.backgroundColor = TaskitColor.button
                }
            default:
                break
            }
        }
    }

}
