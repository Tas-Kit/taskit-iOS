//
//  InvitationView.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class InvitationView: UIView {

    lazy var nameTf: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = LocalizedString("请输入用户名")
        tf.delegate = self
        tf.returnKeyType = .send
        return tf
    }()
    
    var inviteBlock: ((_ name: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.text = LocalizedString("成员")
        nameLabel.sizeToFit()
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        
        let inviteBtn = UIButton()
        inviteBtn.setTitleColor(TaskitColor.button, for: .normal)
        inviteBtn.layer.masksToBounds = true
        inviteBtn.layer.cornerRadius = 5
        inviteBtn.layer.borderColor = TaskitColor.button.cgColor
        inviteBtn.layer.borderWidth = 1
        inviteBtn.setTitle(LocalizedString("邀请"), for: .normal)
        inviteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        inviteBtn.addTarget(self, action: #selector(invite), for: .touchUpInside)
        addSubview(inviteBtn)
        inviteBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        addSubview(nameTf)
        nameTf.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.right.equalTo(inviteBtn.snp.left).offset(-10)
            make.centerY.height.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func invite() {
        inviteBlock?(nameTf.text ?? "")
    }
}

extension InvitationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        invite()
        return true
    }
}
