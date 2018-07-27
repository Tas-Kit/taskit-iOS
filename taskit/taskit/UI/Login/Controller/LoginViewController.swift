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

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBindings()
    }
    
    func setupBindings() {
        let viewModel = LoginViewModel()
        
        usernameTf.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordTf.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        //is button enabled
        viewModel.loginButtonEnable.subscribe(onNext: { [weak self] (value) in
            self?.loginButton.isEnabled = value
        }).disposed(by: disposeBag)
        
        //login
        loginButton.rx.tap.subscribe(onNext: {
            HelloToast.showLoading()
            LoginService.login(username: viewModel.username.value, password: viewModel.password.value, success: {
                HelloToast.hideToast()
            }, failed: { (reason) in
                HelloToast.hideToast()
                HelloToast.showTip(reason ?? "登录失败")
            })
        }).disposed(by: disposeBag)
    }

    @IBAction func login() {
       
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
