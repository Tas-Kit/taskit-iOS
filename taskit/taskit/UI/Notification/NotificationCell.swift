//
//  NotificationCell.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    lazy var checkView: UIView = {
        let v = UIView()
        let acceptBtn = UIButton()
        acceptBtn.setImage(#imageLiteral(resourceName: "check_accept"), for: .normal)
        acceptBtn.addTarget(self, action: #selector(accept), for: .touchUpInside)
        v.addSubview(acceptBtn)
        acceptBtn.snp.makeConstraints({ (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        })
        let rejectBtn = UIButton()
        rejectBtn.setImage(#imageLiteral(resourceName: "check_reject"), for: .normal)
        rejectBtn.addTarget(self, action: #selector(reject), for: .touchUpInside)
        v.addSubview(rejectBtn)
        rejectBtn.snp.makeConstraints({ (make) in
            make.right.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        })
        return v
    }()
    
    var taskModel: TaskModel?
    var checkBlock: ((_ status: Acceptance, _ model: TaskModel?) -> Swift.Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(checkView)
        checkView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.height.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func accept() {
        checkBlock?(.accept, self.taskModel)
    }
    
    @objc func reject() {
        checkBlock?(.reject, self.taskModel)
    }
}
