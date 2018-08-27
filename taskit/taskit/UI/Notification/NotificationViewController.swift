//
//  NotificationViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {
    
    lazy var positionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = TaskitColor.majorText
        l.font = UIFont.systemFont(ofSize: 16)
        l.text = LocalizedString("暂时还没有邀请")
        self.table.addSubview(l)
        l.snp.makeConstraints({ (make) in
            make.left.right.width.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        return l
    }()
    
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.rowHeight = 45.0
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.separatorColor = TaskitColor.separatorColor
        t.es.addPullToRefresh {[weak self] in
            self?.requestData()
        }
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
        
        view.makeToastActivity(.center)
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.viewTrack("Notifications")
    }
    
    func requestData() {
        NotificationManager.fetchNotifications(success: {
            self.view.hideToastActivity()
            self.table.reloadData()
            self.positionLabel.isHidden = NotificationManager.notifications.count != 0
            self.table.es.stopPullToRefresh()
        }) {
            self.view.hideToastActivity()
            self.table.es.stopPullToRefresh()
        }
    }
    
    func taskRespond(status: Acceptance, tid: String?) {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .respond, method: .post, additionalPath: tid, params: ["acceptance": status.rawValue], success: { (msg, dic) in
            self.view.hideToastActivity()
            
            for (index, task) in NotificationManager.notifications.reversed().enumerated() where task.task?.tid == tid{
                NotificationManager.notifications.remove(at: index)
                break
            }
            self.table.reloadData()
            
            self.positionLabel.isHidden = NotificationManager.notifications.count != 0

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
        return NotificationManager.notifications.count
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
        
        let task = NotificationManager.notifications[indexPath.row]
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
