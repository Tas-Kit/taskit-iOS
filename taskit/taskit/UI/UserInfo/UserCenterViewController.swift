//
//  UserCenterViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/2.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout() {
        var controllers = self.navigationController?.viewControllers
        controllers?.insert(LoginViewController(), at: 0)
        self.navigationController?.viewControllers = controllers!
        self.navigationController?.popToRootViewController(animated: true)
        
        CookieManager.cleanCookies()
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
