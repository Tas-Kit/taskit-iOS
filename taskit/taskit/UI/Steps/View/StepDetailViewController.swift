//
//  StepDetailViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/6.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class StepDetailViewController: BaseViewController {
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.separatorStyle = .none
        return t
    }()
    
    lazy var triggerButton: StepTriggerButton = {
        let button = StepTriggerButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 80, height: 40)
        button.backgroundColor = TaskitColor.button
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(trigger), for: .touchUpInside)
        return button
    }()
    
    var sectionColor: UIColor
    let opSwitch = UISwitch()
    let prompts = [LocalizedString("步骤名称") + ": ",
                   LocalizedString("截止日期") + ": ",
                   LocalizedString("期望投入") + ": ",
                   LocalizedString("步骤描述") + ": ",
                   LocalizedString("可跳过") + ": ",
                   LocalizedString("执行人") + ": ",
                   LocalizedString("审阅人") + ": "]
    
    var stepResponse: StepResponse?
    var step: StepModel
    var tid: String?
    
    init(_ step: StepModel, color: UIColor) {
        self.step = step
        self.sectionColor = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("步骤信息")
        view.backgroundColor = .white
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configTriggerButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = sectionColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = TaskitColor.navigation
    }
    
    func configTriggerButton() {
        if let status = step.status {
            switch status {
            case .inProgress, .readyForReview:
                let myRole = RoleManager.myRole(of: stepResponse)
                //config
                triggerButton.config(step: step, myRole: myRole)
                view.addSubview(triggerButton)
                triggerButton.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                    make.bottom.equalTo(bottomLayoutGuide.snp.top)
                }
            default:
                break
            }
        }
    }

    @objc func trigger() {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .trigger,
                               method: .post,
                               additionalPath: tid,
                               params: ["tid": tid ?? "", "sid": step.sid ?? ""],
                               success: { (msg, dic) in
            self.view.hideToastActivity()
            self.navigationController?.popViewController(animated: true)
            let response = StepResponse(JSON: dic)
            StepService.updateSteps(response)
                                NotificationCenter.default.post(name: .kUpdateStepTabbarSelectedIndex, object: nil, userInfo: ["index": 0])
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg)
        }
    }
}

extension StepDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = prompts[indexPath.row] + (step.name ?? "")
        case 1:
            cell?.textLabel?.text = prompts[indexPath.row] + (step.deadline ?? "").components(separatedBy: "T")[0]
        case 2:
            var content = prompts[indexPath.row]
            if let time = step.expected_effort_num {
                content.append("\(time) " + (step.expected_effort_unit?.descrition ?? ""))
            }
            cell?.textLabel?.text = content
        case 3:
            cell?.textLabel?.text = prompts[indexPath.row] + (step.description ?? "")
        case 4:
            cell?.textLabel?.text = prompts[indexPath.row]
            opSwitch.isOn = step.is_optional ?? false
            opSwitch.isEnabled = false
            cell?.contentView.addSubview(opSwitch)
            let textWitdh = (prompts[indexPath.row] as NSString).boundingRect(with: CGSize(width: 200, height: 200), options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: (cell?.textLabel?.font)!], context: nil).size.width
            opSwitch.snp.makeConstraints { (make) in
                make.left.equalTo(textWitdh + 30)
                make.centerY.equalToSuperview()
            }
        case 5:
            cell?.textLabel?.text = prompts[indexPath.row] + (step.assignees ?? []).joined(separator: ",")
        case 6:
            cell?.textLabel?.text = prompts[indexPath.row] + (step.reviewers ?? []).joined(separator: ",")
        default:
            break
        }
   
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
