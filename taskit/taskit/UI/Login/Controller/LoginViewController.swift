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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notice:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let username = KeychainTool.value(forKey: .username) as? String {
            usernameTf.text = username
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = TaskitColor.navigation
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: Constants.navigationTitleFont]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endInput()
    }
    
    func setTexts() {
        promptLabel1.text = LocalizedString("用户名/邮箱") + "*"
        promptLabel2.text = LocalizedString("密码") + "*"
        loginButton.setTitle(LocalizedString("登录"), for: .normal)
        forgetButon.setTitle(LocalizedString("忘记密码") + "?", for: .normal)
        registButton.setTitle(LocalizedString("立即注册"), for: .normal)
    }
    
    func setupBindings() {
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
        guard let username = usernameTf.text, !username.isEmpty else {
            self.view.makeToast(LocalizedString("用户名/邮箱不能为空"))
            return
        }
        
        guard let password = passwordTf.text, !password.isEmpty else {
            self.view.makeToast(LocalizedString("密码不能为空"))
            return
        }
        
        endInput()
        
        self.view.makeToastActivity(.center)
        LoginService.login(username: username, password: password, success: {
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
    func prepareForInput(_ keyboardH: CGFloat) {
        let loginBtnFrame = loginButton.superview?.convert(loginButton.frame, to: self.view) ?? .zero
        guard (UIScreen.main.bounds.height - keyboardH) < loginBtnFrame.maxY else {
            return
        }
        
        let offset = loginBtnFrame.maxY - (UIScreen.main.bounds.height - keyboardH)
        
        UIView.animate(withDuration: 0.25) {
            var frame = self.view.frame
            frame.origin.y = -offset - 40
            self.view.frame = frame
        }
    }
    
    func endInput() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.25) {
            var frame = self.view.frame
            frame.origin.y = 0
            self.view.frame = frame
        }
    }
    
    @objc func keyboardWillChangeFrame(notice: Notification) {
        if view.frame.minY == 0 {
            if let value = notice.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardH = value.cgRectValue.height
                prepareForInput(keyboardH)
            }
            
        }
    }
    
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
