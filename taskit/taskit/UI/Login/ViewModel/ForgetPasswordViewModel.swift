//
//  ForgetPasswordViewModel.swift
//  taskit
//
//  Created by xieran on 2018/7/30.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import RxSwift

class ForgetPasswordViewModel {
    var email = Variable<String>("")
    var verifyCode = Variable<String>("")
    var password = Variable<String>("")
    
    var emailValid: Observable<Bool>
    var verfiCodeValid: Observable<Bool>
    var passwordValid: Observable<Bool>
    
    var resetButtonEnable: Observable<Bool>
    
    init() {
        emailValid = email.asObservable().map({ (str) -> Bool in
            return !str.isEmpty
        })
        
        verfiCodeValid = verifyCode.asObservable().map({ (str) -> Bool in
            return !str.isEmpty
        })
        
        passwordValid = password.asObservable().map({ (str) -> Bool in
            return !str.isEmpty
        })
        
        resetButtonEnable = Observable.combineLatest(emailValid, verfiCodeValid, passwordValid) {(mailValid, codeValid, pwdValid) in
            if mailValid == true, codeValid == true, pwdValid == true {
                return true
            } else {
                return false
            }
        }
    }
}
