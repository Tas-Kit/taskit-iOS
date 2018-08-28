//
//  UIViewController+Extension.swift
//  taskit
//
//  Created by xieran on 2018/8/18.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

extension UIViewController {
    /// Returns the current application's top view controller.
    open class var top : UIViewController? {
        return self.top(of: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    /// Returns the top most view controller from given view controller's stack.
    class func top(of viewController: UIViewController? ) -> UIViewController? {
        /// UITabBarController
        if let tabBarViewController = viewController as? UITabBarController, let selectedViewController = tabBarViewController.selectedViewController {
            return self.top(of: selectedViewController)
        }
        
        /// UINavigationController
        if let navigationCotroller = viewController as? UINavigationController, let visibleController = navigationCotroller.visibleViewController {
            return self.top(of: visibleController)
        }
        
        /// presentedViewController
        if let presentViewController = viewController?.presentedViewController {
            return self.top(of: presentViewController)
        }
        
        /// child viewController
        for subView in viewController?.view?.subviews ?? [] {
            if let childViewController = subView.next as? UIViewController {
                return self.top(of: childViewController)
            }
        }
        
        return viewController
    }
}

extension UIViewController {
    func pageAliasArray() -> [String] {
        var result = [String]()
        if let nav = self.navigationController {
            nav.viewControllers.forEach { (vc) in
                if vc is UITabBarController {
                    if let currentVc = (vc as! UITabBarController).selectedViewController {
                        result.append((currentVc as? BaseViewController)?.pageAlias ?? "unknown")
                    }
                } else {
                    result.append((vc as? BaseViewController)?.pageAlias ?? "")
                }
            }
        }
        return result
    }
}
