//
//  TaskStoreViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/20.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TaskStoreViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = LocalizedString("任务商店")
    }

}
