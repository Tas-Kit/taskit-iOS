//
//  LoginViewModel.swift
//  taskit
//
//  Created by xieran on 2018/7/27.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    var username = Variable<String>("")
    var password = Variable<String>("")
    var usernameValid: Observable<Bool>
    var passwordValid: Observable<Bool>
    
    var loginButtonEnable: Observable<Bool>
    
    init() {
        usernameValid = username.asObservable().map({ (str) -> Bool in
            return str.isEmpty ? false : true
        })

        passwordValid = password.asObservable().map({ (str) -> Bool in
            return str.isEmpty ? false : true
        })
        
        loginButtonEnable = Observable.combineLatest(usernameValid.asObservable(), passwordValid.asObservable()) {(nameValid, pwdValid) in
            if nameValid == true, pwdValid == true {
                return true
            } else {
                return false
            }
        }
    }
}
