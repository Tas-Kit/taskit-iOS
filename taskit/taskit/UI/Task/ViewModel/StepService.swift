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
    
    static func requestSteps(tid: String?) {
        NetworkManager.request(urlString: NetworkApiPath.graph.rawValue + (tid ?? ""), method: .get, params: nil, success: { (msg, dic) in
            let response = StepResponse(JSON: dic)
            StepService.steps.removeAll()
            if let steps = response?.steps?.filter({ (step) -> Bool in
                return step.node_type == .n
            }) {
                StepService.steps.append(contentsOf: steps)
            }
            
            NotificationCenter.default.post(name: .kDidGetSteps, object: nil)
        }) { (code, msg, dic) in
            StepService.steps.removeAll()
            NotificationCenter.default.post(name: .kDidGetSteps, object: nil)
        }
        
    }
}
