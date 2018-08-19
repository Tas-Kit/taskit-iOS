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

    lazy var rightItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showNotification))
        return item
    }()
    
    lazy var notiBadge: UILabel = {
        let width: CGFloat = 15.0
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = TaskitColor.notiNumBackground
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = width / 2
        label.text = "\(NotificationManager.notifications.count)"
        self.navigationController?.navigationBar.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview().offset(-5)
            make.width.height.equalTo(width)
        })
        return label
    }()
    
    var pageNum = 0
    var tasks = [TaskModel]()
    var searchResults = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("Home Page")
        navigationItem.leftBarButtonItem = leftItem()
        view.backgroundColor = TaskitColor.screenBackground
        
        (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(usernameFirstLetter(), for: .normal)
        navigationItem.rightBarButtonItem = rightItem

        supportPopGesture = false
        
        table.es.addPullToRefresh {[weak self] in
            self?.requestData()
        }
        
        view.makeToastActivity(.center)
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRefreshNotice(notice:)), name: .kHomeRefresh, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        updateNotiBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notiBadge.isHidden = true
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
            self.updateNotiBadge()
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

    @objc func updateNotiBadge() {
        self.notiBadge.text = "\(NotificationManager.notifications.count)"
        if NotificationManager.notifications.count > 0, navigationController?.topViewController == self {
            self.notiBadge.isHidden = false
        } else {
            self.notiBadge.isHidden = true
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
    
    @objc func showNotification() {
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    @objc func userCenter() {
        self.navigationController?.pushViewController(UserCenterViewController(), animated: true)
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
    func leftItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.size.width / 2
        button.backgroundColor = TaskitColor.profileBackground
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.addTarget(self, action: #selector(userCenter), for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }
    
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
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let arr = searchResults.count > 0 ? searchResults : tasks
        let model = arr[indexPath.row]
        let vc = StepsTabbarController(task: model)
        vc.navigationItem.title = model.task?.name
        self.navigationController?.pushViewController(vc, animated: true)
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

