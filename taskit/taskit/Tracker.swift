//
//  Tracker.swift
//  taskit
//
//  Created by xieran on 2018/8/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class Tracker: NSObject {
    static func setup() {
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        
        gai.tracker(withTrackingId: "UA-118672792-1")
        gai.trackUncaughtExceptions = true
        gai.logger.logLevel = .verbose;
    }
    
    static func viewTrack(_ viewName: String) {
        if let builder = GAIDictionaryBuilder.createScreenView() {
            GAI.sharedInstance().defaultTracker.set(kGAIScreenName, value: viewName)
            if let params = builder.build() as? [AnyHashable: Any] {
                GAI.sharedInstance().defaultTracker.send(params)
            }
        }
    }
    
    static func actionTrack(category: String, action: String, label: String? = nil, value: Int? = 0) {
        if let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label ?? "", value: NSNumber(value: (value ?? 0))) {
            if let params = builder.build() as? [AnyHashable: Any] {
                GAI.sharedInstance().defaultTracker.send(params)
            }
        }
    }
}
