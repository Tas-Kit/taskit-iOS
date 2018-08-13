//
//  NotificationViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    var tasks = [TaskModel]()
    
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.rowHeight = 45.0
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.separatorColor = TaskitColor.separatorColor
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("通知")
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        requestData()
    }
    
    func requestData() {
        view.makeToastActivity(.center)
        NetworkManager.request(urlString: NetworkApiPath.task.rawValue + "?format=json", method: .get, params: nil, success: { (msg, dic) in
            self.view.hideToastActivity()
            for (_, value) in dic {
                if let dic = value as? [String: Any], let model = TaskModel(JSON: dic), model.hasTask?.acceptance == .waiting {
                    self.tasks.append(model)
                }
            }
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
        }
    }
    
    func taskRespond(status: Acceptance, tid: String?) {
        guard let _tid = tid else {
            view.makeToast("tid error")
            return
        }
        
        view.makeToastActivity(.center)
        NetworkManager.request(urlString: NetworkApiPath.respond.rawValue + _tid + "/", method: .post, params: ["acceptance": status.rawValue], success: { (msg, dic) in
            self.view.hideToastActivity()
            for (index, task) in self.tasks.reversed().enumerated() where task.task?.tid == tid{
                self.tasks.remove(at: index)
                break
            }
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg)
        }
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

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Notification") as? NotificationCell
        if cell == nil {
            cell = NotificationCell(style: .default, reuseIdentifier: "Notification")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.separatorInset = .zero
            cell?.backgroundColor = .white
            cell?.selectionStyle = .none
            cell?.checkBlock = {[weak self] (status, model) in
                self?.taskRespond(status: status, tid: model?.task?.tid)
            }
        }
        
        let task = tasks[indexPath.row]
        cell?.textLabel?.text = "   " + (task.task?.name ?? "")
        cell?.taskModel = task
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
