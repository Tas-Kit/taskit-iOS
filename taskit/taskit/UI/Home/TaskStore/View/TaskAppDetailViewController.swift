//
//  TaskAppDetailViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/22.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TaskAppDetailViewController: BaseViewController {

    var app: TaskStoreAppModel?
    var response: TaskModel?
    
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.dataSource = self
        t.delegate = self
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.separatorStyle = .none
        t.backgroundColor = .clear
        return t
    }()
    
    lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(LocalizedString("下载"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = TaskitColor.button
        btn.addTarget(self, action: #selector(download), for: .touchUpInside)
        return btn
    }()
    
    lazy var dateformatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    let font = UIFont.systemFont(ofSize: 14)
    let lineBreakMode = NSLineBreakMode.byCharWrapping
    let prompts = [LocalizedString("下载量") + ": ",
                   LocalizedString("任务描述") + ": ",
                   LocalizedString("创建时间") + ": ",
                   LocalizedString("更新时间") + ": ",
                   LocalizedString("角色") + ": ",
                   LocalizedString("创建者") + ": "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = app?.name
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.height.equalTo(50)
        }
        
        requestData()
    }
    
    @objc func requestData() {
        guard let appId = app?.app_id else {
            return
        }
        NetworkManager.request(apiPath: .taskStore, method: .get, additionalPath: "\(appId)/download", success: { (msg, dic) in
            self.response = TaskModel(JSON: dic)
            self.table.reloadData()
        }) { (code, msg, dic) in
            
        }
    }
    
    @objc func download() {
        guard let appId = app?.app_id else {
            return
        }
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .taskStore, method: .get, additionalPath: "\(appId)/download", success: { (msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("下载成功"))
            NotificationCenter.default.post(name: .kTaskStoreDownloadSuccess, object: nil, userInfo: dic)
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
        }
    }
    
    private func text(at indexPath: IndexPath) -> String {
        let prompt = prompts[indexPath.row]
        switch indexPath.row {
        case 0:
            return prompt + "\(app?.downloads ?? 0)"
        case 1:
            return prompt + "\(app?.description ?? "")"
        case 2:
            var dateStr = ""
            if let date = Tools.serverDate(dateStr: app?.created_date ?? "") {
                dateStr = self.dateformatter.string(from: date)
            }
            return prompt + dateStr
        case 3:
            var dateStr = ""
            if let date = Tools.serverDate(dateStr: app?.last_update ?? "") {
                dateStr = self.dateformatter.string(from: date)
            }
            return prompt + dateStr
        case 4:
            return prompt + (response?.task?.roles?.joined(separator: ",") ?? "")
        case 5:
            return prompt + (app?.author?.username ?? "")
        default:
            return ""
        }
    }
}

extension TaskAppDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TaskAppDetail")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "TaskAppDetail")
            cell?.backgroundColor = .white
            cell?.selectionStyle = .none
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.textLabel?.textAlignment = .left
            cell?.textLabel?.font = font
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.lineBreakMode = lineBreakMode
        }
        
        cell?.textLabel?.text = text(at: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = text(at: indexPath)
        return str.size(font, UIScreen.main.bounds.width - 40, CGFloat(MAXFLOAT), lineBreakMode: lineBreakMode).height + 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
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
