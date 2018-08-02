//
//  RegistViewController.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class RegistViewController: BaseViewController {
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var promptLabel1: UILabel!
    @IBOutlet weak var promptLabel2: UILabel!
    @IBOutlet weak var promptLabel3: UILabel!
    @IBOutlet weak var registButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("注册")
        // Do any additional setup after loading the view.
        
        setTexts()
    }
    
    func setTexts() {
        promptLabel1.text = LocalizedString("用户名") + "*"
        promptLabel1.text = LocalizedString("邮箱") + "*"
        promptLabel1.text = LocalizedString("密码") + "*"
        registButton.setTitle(LocalizedString("注册"), for: .normal)
    }
    
    @IBAction func regist() {
        guard usernameTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("用户名不能为空"))
            return
        }
        
        guard emailTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("邮箱不能为空"))
            return
        }
        
        guard passwordTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("密码不能为空"))
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
            if msg != nil {
                self.view.makeToast(msg)
            }
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

extension RegistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
