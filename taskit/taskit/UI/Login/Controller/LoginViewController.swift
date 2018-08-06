//
//  LoginViewController.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetButon: UIButton!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var baseScroll: UIScrollView!
    @IBOutlet weak var promptLabel1: UILabel!
    @IBOutlet weak var promptLabel2: UILabel!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("忘记密码")
        view.backgroundColor = .white
        
        baseScroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 580)
        if #available(iOS 11.0, *) {
            baseScroll.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            automaticallyAdjustsScrollViewInsets = false
        }
        setTexts()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setTexts() {
        promptLabel1.text = LocalizedString("用户名/邮箱") + "*"
        promptLabel2.text = LocalizedString("密码") + "*"
        loginButton.setTitle(LocalizedString("登录"), for: .normal)
        forgetButon.setTitle(LocalizedString("忘记密码") + "?", for: .normal)
        registButton.setTitle(LocalizedString("立即注册"), for: .normal)
    }
    
    func setupBindings() {
        let viewModel = LoginViewModel()
        
        usernameTf.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordTf.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        //login
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            guard !viewModel.username.value.isEmpty else {
                self?.view.makeToast(LocalizedString("用户名/邮箱不能为空"))
                return
            }
            
            guard !viewModel.password.value.isEmpty else {
                self?.view.makeToast(LocalizedString("密码不能为空"))
                return
            }
            
            self?.view.endEditing(true)
            
            self?.view.makeToastActivity(.center)
            LoginService.login(username: viewModel.username.value, password: viewModel.password.value, success: {
                self?.view.hideToastActivity()
                self?.loginSuccess(username: viewModel.username.value, password: viewModel.password.value)
            }, failed: { (reason) in
                self?.view.hideToastActivity()
                if reason != nil {
                    self?.view.makeToast(reason)
                }
            })
        }).disposed(by: disposeBag)
        
        //forget password
        forgetButon.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.pushViewController(ForgetPasswordViewController(), animated: true)
        }).disposed(by: disposeBag)
        
        //regist
        registButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.pushViewController(RegistViewController(), animated: true)
        }).disposed(by: disposeBag)
    }
    
    func loginSuccess(username: String, password: String) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
