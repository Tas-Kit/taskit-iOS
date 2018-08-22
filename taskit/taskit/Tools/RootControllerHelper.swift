//
//  RootControllerHelper.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

struct RootControllerHelper {
    static var home: UIViewController {
        return HomeTabbarViewController()
    }

    static func rootViewController() -> UIViewController {
        let nav: BaseNavigationController!
        if LoginService.isLogin == true {
            nav = BaseNavigationController(rootViewController: home)
        } else {
            nav = BaseNavigationController(rootViewController: LoginViewController())
        }
        return nav
    }

}
