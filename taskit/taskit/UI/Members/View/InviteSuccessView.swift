//
//  InviteSuccessView.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class InviteSuccessView: UIView {

    static func show() {
        let mask = InviteSuccessView()
        mask.backgroundColor = UIColor(white: 0, alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(mask)
        mask.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let background = UIView()
        background.backgroundColor = .white
        background.layer.masksToBounds = true
        background.layer.cornerRadius = 10
        mask.addSubview(background)
        background.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width - 80)
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(400)
        }
        
        let closeBtn = UIButton()
        closeBtn.setBackgroundImage(#imageLiteral(resourceName: "close_blue"), for: .normal)
        closeBtn.addTarget(mask, action: #selector(close), for: .touchUpInside)
        background.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(36)
        }
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "success_blue"))
        background.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        
        let label = UILabel()
        label.text = LocalizedString("邀请已发出")
        label.textColor = TaskitColor.button
        label.font = UIFont.systemFont(ofSize: 18)
        background.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        let continueBtn = UIButton()
        continueBtn.backgroundColor = TaskitColor.button
        continueBtn.setTitle(LocalizedString("继续邀请"), for: .normal)
        continueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.layer.masksToBounds = true
        continueBtn.layer.cornerRadius = 10
        continueBtn.addTarget(mask, action: #selector(close), for: .touchUpInside)
        background.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
    }

    static func dismiss() {
        for v in UIApplication.shared.keyWindow?.subviews ?? [] where v is InviteSuccessView {
            v.removeFromSuperview()
        }
    }
    
    @objc func close() {
        InviteSuccessView.dismiss()
    }
}
