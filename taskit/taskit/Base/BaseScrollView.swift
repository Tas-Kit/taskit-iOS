//
//  BaseScrollView.swift
//  taskit
//
//  Created by xieran on 2018/8/23.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class BaseScrollView: UIScrollView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesBegan(touches, with: event)
    }

}
