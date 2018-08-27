//
//  HomeViewController.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HomeViewController: BaseViewController {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchTable: UITableView!
    
    var pageNum = 0
    var tasks = [TaskModel]()
    var searchResults = [TaskModel]()
    
    override var pageAlias: String {
        return "Task List"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = TaskitColor.screenBackground

        supportPopGesture = false
        
        table.es.addPullToRefresh {[weak self] in
            self?.requestData()
        }
        
        view.makeToastActivity(.center)
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRefreshNotice(notice:)), name: .kHomeRefresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taskStoreDownloadSuccess(notice:)), name: .kTaskStoreDownloadSuccess, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = LocalizedString("任务列表")
    }
    
    func requestData() {
        NetworkManager.request(apiPath: .task, method: .get, params: nil, success: { (msg, dic) in
            self.view.hideToastActivity()
            self.table.es.stopPullToRefresh()
            self.tasks.removeAll()
            NotificationManager.notifications.removeAll()
            for (_, value) in dic {
                if let dic = value as? [String: Any], let model = TaskModel(JSON: dic) {
                    if model.hasTask?.acceptance == .accept {
                        self.tasks.append(model)
                    }
                    if model.hasTask?.acceptance == .waiting {
                        NotificationManager.notifications.append(model)
                    }
                }
            }
            self.sortTask()
            (self.tabBarController as? HomeTabbarViewController)?.updateNotiBadge()
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.table.es.stopPullToRefresh()
        }
    }
    
    func sortTask() {
        self.tasks.sort { (task1, task2) -> Bool in
            let priority1 = (task1.task?.status?.priority ?? 0)
            let priority2 = (task2.task?.status?.priority ?? 0)
            if priority1 > priority2 {
                return true
            } else if priority1 == priority2 {
                return (task1.task?.name ?? "") < (task2.task?.name ?? "")
            } else {
                return false
            }
        }
    }
    
    @objc func trigger(_ sender: UIButton) {
        let task = self.tasks[sender.tag]
        
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .trigger,
                               method: .post,
                               additionalPath: task.task?.tid ?? "",
                               success: { (msg, dic) in
                                self.view.hideToastActivity()
                                NotificationCenter.default.post(name: .kHomeRefresh, object: nil)
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(msg)
        }
    }

    @objc func didReceiveRefreshNotice(notice: Notification) {
        let pullRefresh = notice.userInfo?["pullRefresh"] as? Bool
        if pullRefresh == true {
            table.es.startPullToRefresh()
        } else {
            view.makeToastActivity(.center)
            requestData()
        }
    }
    
    @objc func taskStoreDownloadSuccess(notice: Notification) {
        if let dic = notice.userInfo as? [String: Any], let task = TaskModel(JSON: dic) {
            task.isDownloaded = true
            self.tasks.insert(task, at: 0)
            self.table.reloadData()
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

extension HomeViewController {
    func startButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(LocalizedString("启动"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        btn.backgroundColor = TaskitColor.button
        btn.addTarget(self, action: #selector(trigger(_:)), for: .touchUpInside)
        return btn
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchTable {
            return searchResults.count
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Home")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Home")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.backgroundColor = .white
            cell?.imageView?.isUserInteractionEnabled = true
            cell?.imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapIcon(gesture:))))
        }
        cell?.imageView?.tag = indexPath.row
        
        let model = tableView == self.searchTable ? searchResults[indexPath.row] : tasks[indexPath.row]
        cell?.textLabel?.text = model.task?.name
        
        cell?.imageView?.image = UIImage(named: "task_" + (model.task?.status?.rawValue ?? "default"))
        if model.task?.status == .new {
            let btn = (cell?.accessoryView as? UIButton) ?? startButton()
            btn.tag = indexPath.row
            cell?.accessoryView = btn
        } else {
            cell?.accessoryView = nil
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = tableView == self.searchTable ? searchResults[indexPath.row] : tasks[indexPath.row]
        if model.isDownloaded {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            v.backgroundColor = .lightGray
            cell.backgroundView = v
        } else {
            cell.backgroundView = nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let task = tasks[indexPath.row]
        return task.hasTask?.super_role == .owner ? LocalizedString("删除") : LocalizedString("离开")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        quitTask(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = searchResults.count > 0 ? searchResults : tasks
        let model = arr[indexPath.row]
        model.isDownloaded = false
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        let vc = StepsTabbarController(task: model)
        vc.navigationItem.title = model.task?.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    @objc func tapIcon(gesture: UITapGestureRecognizer) {
        if let imgView = gesture.view as? UIImageView {
            let task = tasks[imgView.tag]
            let urlString = NetworkConfiguration.taskPreviewUrl + (task.task?.tid ?? "") + "/"
            let vc = TaskitWebviewController(urlString: urlString)
            vc.navigationItem.title = LocalizedString("预览")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func quitTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]

        var apiPath: NetworkApiPath!
        var alertString = ""
        var params = [String: Any]()
        var method: HTTPMethod!
        if task.hasTask?.super_role == .owner {
            apiPath = .task
            method = .delete
            alertString = LocalizedString("你确定想要永久删除这一任务吗")
        } else {
            apiPath = .respond
            params = ["acceptance": Acceptance.reject.rawValue]
            method = .post
            alertString = LocalizedString("你确定要永久退出这一任务吗")
        }
        
        TaskitAlertController.show(title: alertString, message: nil, desctructiveTitle: LocalizedString("确定"), handler: {
            self.view.makeToastActivity(.center)
            NetworkManager.request(apiPath: apiPath, method: method, additionalPath: task.task?.tid ?? "", params: params, success: { (msg, dic) in
                self.view.hideToastActivity()
                self.tasks.remove(at: indexPath.row)
                self.table.reloadData()
            }) { (code, msg, dic) in
                self.view.hideToastActivity()
                self.view.makeToast(msg)
            }
        })
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        table.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.resignFirstResponder()
        table.isHidden = false
        searchResults.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        tasks.forEach { (model) in
            if let name = model.task?.name, name.lowercased().contains(searchText.lowercased()) {
                searchResults.append(model)
            }
        }
        searchTable.reloadData()
    }
}

