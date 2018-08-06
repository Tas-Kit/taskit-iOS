//
//  StepService.swift
//  taskit
//
//  Created by xieran on 2018/8/6.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

class StepService {
    static var steps = [StepModel]()
    
    static func contentsOf(_ statuses: [StepStatus]) -> [StepModel]{
        var results = [StepModel]()
        statuses.forEach { (status) in
            for model in steps where model.status == status {
                results.append(model)
            }
        }
        return results
    }
}
