//
//  TodoListCell.swift
//  taskit
//
//  Created by xieran on 2018/8/21.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {
    static let rowHeight: CGFloat = 70.0
    
    lazy var icon: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var stepNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = TaskitColor.majorText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var triggerButton: StepTriggerButton = {
        let btn = StepTriggerButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        btn.backgroundColor = TaskitColor.button
        return btn
    }()
    
    var unitModel: TodoListUnit? {
        didSet {
            stepNameLabel.text = unitModel?.step?.name
            taskNameLabel.text = unitModel?.task?.name
            if let status = unitModel?.step?.status {
                switch status {
                case .inProgress:
                    icon.image = #imageLiteral(resourceName: "todo_list_ip")
                case .readyForReview:
                    icon.image = #imageLiteral(resourceName: "todo_list_rr")
                default:
                    icon.image = nil
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(stepNameLabel)
        stepNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon.snp.right).offset(10)
            make.centerY.equalTo(self.icon)
        }
        
        contentView.addSubview(taskNameLabel)
        taskNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon).offset(5)
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.accessoryView = triggerButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
