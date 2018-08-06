//
//  ForgetPasswordViewController.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgetPasswordViewController: BaseViewController {
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var verifyCodeTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var promptLabel1: UILabel!
    @IBOutlet weak var promptLabel2: UILabel!
    @IBOutlet weak var promptLabel3: UILabel!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("忘记密码")
        // Do any additional setup after loading the view.
        setTexts()
        setupBindings()
    }
    
    func setTexts() {
        promptLabel1.text = LocalizedString("邮箱") + "*"
        promptLabel2.text = LocalizedString("请输入验证码") + "*"
        promptLabel3.text = LocalizedString("密码") + "*"
        verifyCodeButton.setTitle(LocalizedString("获取验证码"), for: .normal)
        resetButton.setTitle(LocalizedString("重置密码"), for: .normal)
    }
    
    func setupBindings() {
        let viewModel = ForgetPasswordViewModel()
        
        emailTf.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        verifyCodeTf.rx.text.orEmpty.bind(to: viewModel.verifyCode).disposed(by: disposeBag)
        passwordTf.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)

        //length limit = 6
        verifyCodeTf.rx.controlEvent([UIControlEvents.editingChanged]).subscribe(onNext: { [unowned self] () in
            if self.verifyCodeTf.text?.count ?? 0 > Constants.verifyCodeLength {
                self.verifyCodeTf.text = String(self.verifyCodeTf.text!.prefix(6))
            }
        }).disposed(by: disposeBag)
        
        //request for verify code
        verifyCodeButton.rx.tap.subscribe(onNext: { [weak self] in
            guard !viewModel.email.value.isEmpty else {
                self?.view.makeToast(LocalizedString("邮箱不能为空"))
                return
            }
            self?.requestVerifyCode()
        }).disposed(by: disposeBag)
        
        //request
        resetButton.rx.tap.subscribe(onNext: { [weak self] in
            guard !viewModel.email.value.isEmpty else {
                self?.view.makeToast(LocalizedString("邮箱不能为空"))
                return
            }
            
            guard !viewModel.verifyCode.value.isEmpty else {
                self?.view.makeToast(LocalizedString("验证码不能为空"))
                return
            }
            
            //request
            self?.requestResetPassword()
        }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func requestVerifyCode() {
        guard emailTf.text?.count ?? 0 > 0 else {
            view.makeToast(LocalizedString("请输入验证码"))
            return
        }
        
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: NetworkApiPath.verifyCode.rawValue, method: .post, params: ["email": emailTf.text ?? ""], success: { (msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("已发送"))
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            if msg != nil {
                self.view.makeToast(LocalizedString("发送失败"))
            }
        }
    }
    
    func requestResetPassword() {
        view.makeToastActivity(.center)
        
        NetworkManager.request(apiPath: NetworkApiPath.resetPassword.rawValue,
                               method: .post,
                               params: ["email": emailTf.text ?? "",
                                        "code": verifyCodeTf.text ?? "",
                                        "password": passwordTf.text ?? ""],
                               success: { (msg, dic) in
                                self.view.hideToastActivity()
                                self.view.makeToast(LocalizedString("重置成功"), completion: { (_) in
                                    self.navigationController?.popViewController(animated: true)
                                })
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg, duration: 2.0)
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

extension ForgetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
