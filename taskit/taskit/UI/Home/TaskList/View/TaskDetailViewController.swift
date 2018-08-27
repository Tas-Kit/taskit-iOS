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
    
    var quitAlertString = ""
    
    let font = UIFont.systemFont(ofSize: 14)
    let lineBreakMode = NSLineBreakMode.byCharWrapping
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
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
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
    
    lazy var previewButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(LocalizedString("预览"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = TaskitColor.button
        btn.addTarget(self, action: #selector(preview), for: .touchUpInside)
        return btn
    }()
    
    override var pageAlias: String {
        return "Task Detail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = model?.taskInfo?.name
        navigationItem.rightBarButtonItems = rightItems
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(previewButton)
        previewButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        view.addSubview(quitButton)
        quitButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        if SuperRoleManager.mySuperRole(of: model) == .owner {
            quitButton.setTitle(LocalizedString("删除"), for: .normal)
            quitAlertString = LocalizedString("你确定想要永久删除这一任务吗")
        } else {
            quitButton.setTitle(LocalizedString("离开"), for: .normal)
            quitAlertString = LocalizedString("你确定要永久退出这一任务吗")
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
    
    @objc func preview() {
        let urlString = NetworkConfiguration.taskPreviewUrl + (model?.taskInfo?.tid ?? "") + "/"
        let vc = TaskitWebviewController(urlString: urlString)
        vc.navigationItem.title = LocalizedString("预览")
        navigationController?.pushViewController(vc, animated: true)
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
        
        TaskitAlertController.show(title: quitAlertString, message: nil, desctructiveTitle: LocalizedString("确定"), handler: {
            self.view.makeToastActivity(.center)
            NetworkManager.request(apiPath: apiPath, method: method, additionalPath: self.model?.taskInfo?.tid ?? "", params: params, success: { (msg, dic) in
                self.view.hideToastActivity()
                NotificationCenter.default.post(name: .kHomeRefresh,
                                                object: nil,
                                                userInfo: ["pullRefresh": true])
                self.navigationController?.popToRootViewController(animated: true)
            }) { (code, msg, dic) in
                self.view.hideToastActivity()
                self.view.makeToast(msg)
            }
        })
    }
    
    private func text(at indexPath: IndexPath) -> String {
        let prompt = prompts[indexPath.row]
        switch indexPath.row {
        case 0:
            return prompt + (model?.taskInfo?.status?.statusString ?? "")
        case 1:
            return prompt + (model?.taskInfo?.deadline?.components(separatedBy: "T")[0] ?? "")
        case 2:
            return prompt + "\(StepService.steps.count)"
        case 3:
            var content = prompt
            if let time = model?.taskInfo?.expected_effort_num {
                content.append("\(time) " + (model?.taskInfo?.expected_effort_unit?.descrition ?? ""))
            }
            return content
        case 4:
            return prompt + (model?.taskInfo?.description ?? "")
        case 5:
            return prompt + (model?.taskInfo?.roles?.joined(separator: ",") ?? "")
        default:
            return ""
        }
    }
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetail")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "TaskDetail")
            cell?.backgroundColor = .white
            cell?.selectionStyle = .none
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.textLabel?.textAlignment = .left
            cell?.textLabel?.font = font
            cell?.textLabel?.lineBreakMode = lineBreakMode
            cell?.textLabel?.numberOfLines = 0
        }
        
        cell?.textLabel?.text = self.text(at: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.text(at: indexPath).size(font, UIScreen.main.bounds.width - 40, CGFloat(MAXFLOAT), lineBreakMode: lineBreakMode).height + 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        v.backgroundColor = .white
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        v.backgroundColor = .white
        return v
    }
}
