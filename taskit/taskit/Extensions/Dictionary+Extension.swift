//
//  Dictionary+Extension.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

extension Dictionary {
    func handleError(_ callback: (_ errorMsg: String) -> Void) {
        for (_, value) in self {
            if let arr = value as? [String], arr.count > 0 {
                callback(arr[0])
                break
            } else if let errorMsg = value as? String {
                callback(errorMsg)
                break
            }
        }
    }
}
