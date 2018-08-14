//
//  RoleSelectionViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/13.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class RoleSelectionViewController: SuperRoleSelectionController {
    var roles: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configContents() {
        for role in roles ?? [] {
            contents.append(role)
        }
        
        if contents.count == 0 {
            contents.append("None")
            table.isUserInteractionEnabled = false
        }
    }
}
