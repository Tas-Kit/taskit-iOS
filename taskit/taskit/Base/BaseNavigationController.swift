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
        self.navigationBar.barTintColor = TaskitColor.navigation
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print(self.topViewController)
        print(self.topViewController?.preferredStatusBarStyle.rawValue)
        return self.topViewController?.preferredStatusBarStyle ?? .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
