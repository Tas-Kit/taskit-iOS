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
    
    let prompts = [LocalizedString("任务名称") + ": ",
                   LocalizedString("状态") + ": ",
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("详情")
        navigationItem.rightBarButtonItems = rightItems
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
            cell?.textLabel?.text = prompt + (model?.taskInfo?.name ?? "")
        case 1:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.status?.statusString ?? "")
        case 2:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.deadline?.components(separatedBy: "T")[0] ?? "")
        case 3:
            cell?.textLabel?.text = prompt + "\(model?.steps?.count ?? 0)"
        case 4:
            var content = prompt
            if let time = model?.taskInfo?.expected_effort_num {
                content.append("\(time) " + (model?.taskInfo?.expected_effort_unit?.descrition ?? ""))
            }
            cell?.textLabel?.text = content
        case 5:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.description ?? "")
        case 6:
            cell?.textLabel?.text = prompt + (model?.taskInfo?.roles?.joined(separator: ",") ?? "")
        default:
            break
        }
        
        return cell!
    }
}
