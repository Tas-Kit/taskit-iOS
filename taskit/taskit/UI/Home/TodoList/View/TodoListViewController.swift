//
//  TodoListViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/20.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TodoListViewController: BaseViewController {

    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.dataSource = self
        t.delegate = self
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.separatorColor = UIColor(hex: "ececec")
        t.rowHeight = TodoListCell.rowHeight
        return t
    }()
    
    var response: TodoListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = TaskitColor.screenBackground
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        table.es.addPullToRefresh {[weak self] in
            self?.requestTodoList()
        }
        
        view.makeToastActivity(.center)
        requestTodoList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalList(_:)), name: .kDidTriggerStep, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = LocalizedString("待办清单")
    }
    
    @objc func requestTodoList() {
        NetworkManager.request(apiPath: .todoList, method: .get, success: { (msg, dic) in
            self.view.hideToastActivity()
            self.table.es.stopPullToRefresh()
            self.response = TodoListResponse(JSON: dic)
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.table.es.stopPullToRefresh()
        }
    }

    @objc func trigger(_ sender: UIButton) {
        let unit = response?.list?[sender.tag]
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .trigger, method: .post, additionalPath: unit?.task?.tid, params: ["tid": unit?.task?.tid ?? "", "sid": unit?.step?.sid ?? ""], success: { (msg, dic) in
            self.view.hideToastActivity()
            self.table.reloadData()
            NotificationCenter.default.post(name: .kDidTriggerStep, object: nil, userInfo: ["response": dic, "sid": unit?.step?.sid ?? ""])
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg)
        }
    }
    
    @objc func updateLocalList(_ notice: Notification) {
        if let sid = notice.userInfo?["sid"] as? String {
            for (index, unit) in (self.response?.list ?? []).enumerated() {
                if unit.step?.sid == sid {
                    self.response?.list?.remove(at: index)
                    break
                }
            }
        }
        
        guard let dic = notice.userInfo?["response"] as? [String: Any],
            let triggerResponse = StepResponse(JSON: dic) else {
            return
        }
        
        var sids = [String]()
        self.response?.list?.forEach({ (unit) in
            sids.append(unit.step?.sid ?? " ")
        })
        
        for step in triggerResponse.steps ?? [] where !(sids.contains(step.sid ?? "")) {
            if step.status == StatusEnu.readyForReview || step.status == StatusEnu.inProgress {
                let todoUnit = TodoListUnit(JSON: [:])
                todoUnit?.step = step
                todoUnit?.task = triggerResponse.taskInfo
                self.response?.list?.append(todoUnit!)
            }
        }
        self.table.reloadData()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.response?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TodoList") as? TodoListCell
        if cell == nil {
            cell = TodoListCell(style: .default, reuseIdentifier: "TodoList")
        }
        
        let unit = response?.list?[indexPath.row]
        cell?.unitModel = unit
        cell?.triggerButton.tag = indexPath.row
        if cell?.triggerButton.allTargets.count == 0 {
            cell?.triggerButton.addTarget(self, action: #selector(trigger(_:)), for: .touchUpInside)
        }
        cell?.triggerButton.config(step: unit?.step, myRole: unit?.has_task?.role)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let unit = response?.list?[indexPath.row]
        if let step = unit?.step, let status = step.status {
            let stepSection = StepSection(stepStatus: status)
            let vc = StepDetailViewController(step, color: stepSection.backgroundColor)
            vc.tid = unit?.task?.tid
            vc.myRole = unit?.has_task?.role
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
