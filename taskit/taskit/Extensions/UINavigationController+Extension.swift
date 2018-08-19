//
//  UINavigationController+Extension.swift
//  taskit
//
//  Created by xieran on 2018/8/18.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation

extension UINavigationController {
    func popToHomeViewController() {
        for controller in self.viewControllers where controller is HomeViewController {
            self.popToViewController(controller, animated: true)
        }
    }
}
