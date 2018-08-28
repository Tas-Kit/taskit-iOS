//
//  BaseNavigationViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/8.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.isTranslucent = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
