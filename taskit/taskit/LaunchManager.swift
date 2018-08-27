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
        
//        Bugly.start(withAppId: "0c07daab1c")
        setupGoogleAnalyse()
    }
    
    static func setupGoogleAnalyse() {
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        gai.tracker(withTrackingId: "UA-118672792-1")
        gai.trackUncaughtExceptions = true
        gai.logger.logLevel = .verbose;
    }
}
