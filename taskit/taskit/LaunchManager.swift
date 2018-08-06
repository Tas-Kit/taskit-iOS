//
//  LaunchManager.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

struct LaunchManager {
    static func setUp() {        
        /// Toast config
        ToastManager.shared.position = .center
        ToastManager.shared.duration = 1.5
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
