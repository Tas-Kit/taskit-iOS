//
//  TaskStoreCell.swift
//  taskit
//
//  Created by xieran on 2018/8/21.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TaskStoreCell: UITableViewCell {
    lazy var icon: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "task_store_icon"))
        return imgView
    }()
    
    lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = TaskitColor.majorText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        btn.setTitle(LocalizedString("下载"), for: .normal)
        btn.backgroundColor = TaskitColor.button
        return btn
    }()
    
    var app: TaskStoreAppModel? {
        didSet {
            taskNameLabel.text = app?.name
            descriptionLabel.text = app?.description
            downloadsLabel.text = LocalizedString("下载量:") + " \(app?.downloads ?? 0)"
            authorLabel.text = LocalizedString("作者:") + " \(app?.author?.username ?? "")"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(24)
        }
        contentView.addSubview(taskNameLabel)
        taskNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(downloadsLabel)
        downloadsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.taskNameLabel)
            make.top.equalTo(self.taskNameLabel.snp.bottom).offset(4)
        }
        
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.downloadsLabel)
            make.left.equalTo(self.contentView.snp.centerX)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.icon.snp.bottom).offset(8)
        }
        
        accessoryView = downloadButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
