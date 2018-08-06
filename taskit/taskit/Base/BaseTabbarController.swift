//
//  BaseTabbarController.swift
//  taskit
//
//  Created by xieran on 2018/8/3.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = leftItem()
    }
    
    func leftItem(tintColor: UIColor = .white) -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        button.tintColor = tintColor
        button.setImage(#imageLiteral(resourceName: "nav_back_white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(tintColor, for: .normal)
        button.setTitle(LocalizedString("返回"), for: .normal)
        button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }
    
    @objc func pop() {
        navigationController?.popViewController(animated: true)
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
