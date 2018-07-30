//
//  RegistViewController.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController {
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func regist() {
        guard usernameTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("请输入用户名"))
            return
        }
        
        guard emailTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("请输入邮箱"))
            return
        }
        
        guard passwordTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("请输入密码"))
            return
        }
        
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .regist,
                               method: .post,
                               params: ["username": usernameTf.text ?? "",
                                        "password": passwordTf.text ?? "",
                                        "email": emailTf.text ?? ""],
                               success: { (msg, dic) in
                                self.view.hideToastActivity()
                                self.view.makeToast(LocalizedString("注册成功"), completion: { [weak self] (_) in
                                    self?.navigationController?.popViewController(animated: true)
                                })
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg ?? LocalizedString("注册失败"))
        }
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
