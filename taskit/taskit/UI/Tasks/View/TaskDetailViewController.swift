//
//  TaskDetailViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TaskDetailViewController: BaseViewController {
    var model: StepResponse?
    
    var quieAlertString = ""
    let prompts = [LocalizedString("状态") + ": ",
                   LocalizedString("截止日期") + ": ",
                   LocalizedString("总步骤数") + ": ",
                   LocalizedString("期望投入") + ": ",
                   LocalizedString("任务描述") + ": ",
                   LocalizedString("角色") + ": "]
    
    lazy var table: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.separatorStyle = .none
        return t
    }()
    
    lazy var rightItems: [UIBarButtonItem] = {
        let memberItem = UIBarButtonItem(image: #imageLiteral(resourceName: "member").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showMembers))
        let historyItem = UIBarButtonItem(image: #imageLiteral(resourceName: "history").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showHistory))
        return [memberItem]
    }()
    
    lazy var quitButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor(hex: "E64242")
        btn.addTarget(self, action: #selector(quitTask), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = model?.taskInfo?.name
        navigationItem.rightBarButtonItems = rightItems
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(quitButton)
        quitButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        if SuperRoleManager.mySuperRole(of: model) == .owner {
            quitButton.setTitle(LocalizedString("删除"), for: .normal)
            quieAlertString = LocalizedString("你确定想要永久删除这一任务吗")
        } else {
            quitButton.setTitle(LocalizedString("离开"), for: .normal)
            quieAlertString = LocalizedString("你确定要永久退出这一任务吗")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetStepList), name: .kDidGetSteps, object: nil)
    }
    
    @objc func didGetStepList(notice: Notification) {
        self.model = notice.object as? StepResponse
    }
    
    @objc func showMembers() {
        let vc = MemberViewController()
        vc.model = self.model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showHistory() {
        
    }
    
    @objc func quitTask() {
        var apiPath: NetworkApiPath!
        var params = [String: Any]()
        var method: HTTPMethod!
        if SuperRoleManager.mySuperRole(of: model) == .owner {
            apiPath = .task
            method = .delete
        } else {
            apiPath = .respond
            params = ["acceptance": Acceptance.reject.rawValue]
            method = .post
        }
        
        TaskitAlertController.show(title: quieAlertString, message: nil, desctructiveTitle: LocalizedString("确定"), handler: {
            self.view.makeToastActivity(.center)
            NetworkManager.request(apiPath: apiPath, method: method, additionalPath: self.model?.taskInfo?.tid ?? "", params: params, success: { (msg, dic) in
                self.view.hideToastActivity()
                NotificationCenter.default.post(name: .kHomeRefresh,
                                                object: nil,
                                                userInfo: ["pullRefresh": true])
                self.navigationController?.popToHomeViewController()
            }) { (code, msg, dic) in
                self.view.hideToastActivity()
                self.view.makeToast(msg)
            }
        })
    }
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "StepDetail")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "StepDetail")
            cell?.backgroundColor = .white
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.textLabel?.textAlignment = .left
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.selectionStyle = .none
        }
        
        let prompt = prompts[indexPath.row]
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.status?.statusString ?? "")
        case 1:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.deadline?.components(separatedBy: "T")[0] ?? "")
        case 2:
            cell?.textLabel?.text = prompt + "\(StepService.steps.count)"
        case 3:
            var content = prompt
            if let time = model?.taskInfo?.expected_effort_num {
                content.append("\(time) " + (model?.taskInfo?.expected_effort_unit?.descrition ?? ""))
            }
            cell?.textLabel?.text = content
        case 4:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.description ?? "")
        case 5:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.roles?.joined(separator: ",") ?? "")
        default:
            break
        }
        
        return cell!
    }
}
