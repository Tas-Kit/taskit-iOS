//
//  TaskStoreViewModel.swift
//  taskit
//
//  Created by xieran on 2018/8/21.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

class TaskStoreViewModel {
    static func rowHeight(of app: TaskStoreAppModel?) -> CGFloat {
        guard let _ = app else {
            return 0
        }
        
        return (app?.description?.isEmpty ?? true) ? 55.0 : 70.0
    }
}
