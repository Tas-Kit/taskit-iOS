//
//  LaunchManager.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import Bugly

struct LaunchManager {
    static func setUp() {        
        /// Toast config
        ToastManager.shared.position = .center
        ToastManager.shared.duration = 1.5
        
        Bugly.start(withAppId: "0c07daab1c")
    }
}
