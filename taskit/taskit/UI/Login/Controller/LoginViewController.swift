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
    let viewModel = LoginViewModel()

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
        navigationController?.navigationBar.barTintColor = TaskitColor.navigation
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: Constants.navigationTitleFont]
    }
    
    func setTexts() {
        promptLabel1.text = LocalizedString("用户名/邮箱") + "*"
        promptLabel2.text = LocalizedString("密码") + "*"
        loginButton.setTitle(LocalizedString("登录"), for: .normal)
        forgetButon.setTitle(LocalizedString("忘记密码") + "?", for: .normal)
        registButton.setTitle(LocalizedString("立即注册"), for: .normal)
    }
    
    func setupBindings() {
        
        usernameTf.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordTf.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        //login
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.login()
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
    
    func pushToHome() {
        var controllers = navigationController?.viewControllers ?? []
        //remove LoginViewController
        controllers.removeAll()
        controllers.append(RootControllerHelper.home)
        navigationController?.setViewControllers(controllers, animated: true)
    }

    func login() {
        guard !viewModel.username.value.isEmpty else {
            self.view.makeToast(LocalizedString("用户名/邮箱不能为空"))
            return
        }
        
        guard !viewModel.password.value.isEmpty else {
            self.view.makeToast(LocalizedString("密码不能为空"))
            return
        }
        
        self.view.endEditing(true)
        
        self.view.makeToastActivity(.center)
        LoginService.login(username: viewModel.username.value, password: viewModel.password.value, success: {
            self.view.hideToastActivity()
            self.pushToHome()
        }, failed: { (reason) in
            self.view.hideToastActivity()
            if reason != nil {
                self.view.makeToast(reason)
            }
        })
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTf {
            passwordTf.becomeFirstResponder()
            return false
        } else if textField == passwordTf, !(textField.text?.isEmpty ?? true) {
            login()
        }
        return true
    }
}
