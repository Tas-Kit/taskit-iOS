//
//  StepViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/2.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import SnapKit

class StepViewController: BaseViewController {
    enum StepListStatus {
        case finished
        case inProgress
        case notBegin
    }
    
    var status: StepListStatus?
    var sections = [StepSection]()
    var stepResponse: StepResponse?
    
    var tid: String?
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.rowHeight = 50
        return t
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(status: StepListStatus) {
        super.init(nibName: nil, bundle: nil)
        
        self.status = status
        switch status {
        case .finished:
            self.tabBarItem.title = LocalizedString("已完成")
            sections = [StepSection(stepStatus: .completed), StepSection(stepStatus: .skipped)]
        case .inProgress:
            self.tabBarItem.title = LocalizedString("进行中")
            sections = [StepSection(stepStatus: .inProgress), StepSection(stepStatus: .readyForReview)]
        case .notBegin:
            self.tabBarItem.title = LocalizedString("未开始")
            sections = [StepSection(stepStatus: .new)]

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.es.addPullToRefresh {
            StepService.requestSteps(tid: (self.tabBarController as? StepsTabbarController)?.task?.task?.tid)
        }
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        didGetStepList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetStepList), name: .kDidGetSteps, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.viewTrack("Step List")
    }
    
    @objc func didGetStepList() {
        table.es.stopPullToRefresh()
        
        for index in 0..<sections.count {
            let section = sections[index]
            section.steps.removeAll()
            for step in StepService.steps where step.status == section.stepStatus {
                section.steps.append(step)
            }
        }        
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StepViewController {
    func triggerButton() -> StepTriggerButton {
        let btn = StepTriggerButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 25)
        btn.backgroundColor = TaskitColor.button
        btn.addTarget(self, action: #selector(trigger(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc func trigger(_ sender: StepTriggerButton) {
        let tid = stepResponse?.taskInfo?.tid
        let indexPath = sender.indexPath!
        let step = sections[indexPath.section].steps[indexPath.row]
        
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .trigger,
                               method: .post,
                               additionalPath: tid,
                               params: ["tid": tid ?? "", "sid": step.sid ?? ""],
                               success: { (msg, dic) in
                                self.view.hideToastActivity()
                                let response = StepResponse(JSON: dic)
                                StepService.updateSteps(response)
                                for newStep in response?.steps ?? [] where newStep.sid == step.sid {
                                    NotificationCenter.default.post(name: .kDidTriggerStep, object: nil, userInfo: ["status": newStep.status ?? ""])
                                    break
                                    
                                }        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg)
        }
    }
}

extension StepViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = sections[section]
        return sectionModel.steps.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Step") as? StepListCell
        if cell == nil {
            cell = StepListCell.init(style: .default, reuseIdentifier: "Step")
            cell?.backgroundColor = .white
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.textLabel?.textAlignment = .left
            cell?.separatorInset = .zero
            cell?.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        
        let section = sections[indexPath.section]
        let step = section.steps[indexPath.row]
        
        cell?.textLabel?.text = "   " + (step.name ?? "")
        
        cell?.imageView?.image = UIImage(named: "step_" + (step.status?.rawValue ?? "default"))
        
        if let status = step.status {
            switch status {
            case .inProgress, .readyForReview:
                let btn = triggerButton()
                let myRole = RoleManager.myRole(of: self.stepResponse)
                btn.config(step: step, myRole: myRole, indexPath: indexPath)
                cell?.accessoryView = btn
            default:
                cell?.accessoryView = nil
            }
        } else {
            cell?.accessoryView = nil
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = sections[section]
        return model.height
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sections[section]
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: model.height))
        label.text = "      \(model.title)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = model.backgroundColor
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        let step = section.steps[indexPath.row]
        let vc = StepDetailViewController(step, color: section.backgroundColor)
        vc.tid = self.tid
        vc.myRole = RoleManager.myRole(of: stepResponse)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
