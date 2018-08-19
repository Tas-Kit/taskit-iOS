//
//  TaskitAlertController.swift
//  taskit
//
//  Created by xieran on 2018/8/18.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

class TaskitAlertController: NSObject {
    public static func show(controller: UIViewController? = UIViewController.top, title: String?, message: String?, cancelTitle: String? = LocalizedString("取消"), desctructiveTitle: String?, handler : (() -> Swift.Void)?, cancelHandler : (() -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if cancelTitle != nil {
            let actionCancel = UIAlertAction.init(title: cancelTitle, style: .default, handler: { (_) in
                cancelHandler?()
            })
            if #available(iOS 8.3, *) {
                actionCancel.setValue(UIColor(red: 119.0/255.0, green: 119.0/255.0, blue: 119.0/255.0, alpha: 1), forKey: "titleTextColor")
            }
            alert.addAction(actionCancel)
        }
        
        if desctructiveTitle != nil {
            let actionRight = UIAlertAction.init(title: desctructiveTitle, style: .default, handler: { (_) in
                handler?()
            })
            if #available(iOS 8.3, *) {
                actionRight.setValue(UIColor(red: 1, green: 102.0/255.0, blue: 0, alpha: 1), forKeyPath: "titleTextColor")
            }
            alert.addAction(actionRight)
        }
        
        controller?.present(alert, animated: true) {
            
        }
    }
}
