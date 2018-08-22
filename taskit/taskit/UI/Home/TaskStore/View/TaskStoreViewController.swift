//
//  TaskStoreViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/20.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class TaskStoreViewController: BaseViewController {
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = LocalizedString("任务搜索")
        bar.barTintColor = UIColor(hex: "F3F3F3")
        bar.delegate = self
        bar.returnKeyType = .done
        bar.autocapitalizationType = .none

        let searchTf = bar.value(forKey: "_searchField") as? UITextField
        searchTf?.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
        searchTf?.font = UIFont.systemFont(ofSize: 14)
        searchTf?.textColor = TaskitColor.majorText
        searchTf?.enablesReturnKeyAutomatically = false
        return bar
    }()
    
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.dataSource = self
        t.delegate = self
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.separatorColor = UIColor(hex: "ececec")
        t.rowHeight = 70.0
        return t
    }()
        
    var response: TaskStoreResponse?
    var searchResponse: TaskStoreResponse?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = TaskitColor.screenBackground
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        }
        
        table.es.addPullToRefresh {[weak self] in
            self?.requestData()
        }
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.top.equalTo(self.searchBar.snp.bottom)
        }
        
        view.makeToastActivity(.center)
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = LocalizedString("任务商店")
    }

    func requestData() {
        NetworkManager.request(apiPath: .taskStore, method: .get, success: { (msg, dic) in
            self.view.hideToastActivity()
            self.response = TaskStoreResponse(JSON: dic)
            self.table.es.stopPullToRefresh()
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.table.es.stopPullToRefresh()
        }
    }
    
    func searchRequest(str: String) {
        NetworkManager.request(apiPath: .taskStore, method: .get, additionalPath: "?keyword=\(str)", slashEnding: false, success: { (msg, dic) in
            self.searchResponse = TaskStoreResponse(JSON: dic)
            self.table.reloadData()
        }) { (code, msg, dic) in
            
        }
    }
    
    @objc func download(_ sender: UIButton) {
        let app = self.appList?[sender.tag]
        guard let appId = app?.app_id else {
            return
        }
        
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .taskStore, method: .post, additionalPath: "\(appId)/download", success: { (msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("下载成功"))
            NotificationCenter.default.post(name: .kTaskStoreDownloadSuccess, object: nil, userInfo: dic)
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
        }
    }
    
    var appList: [TaskStoreAppModel]? {
        if isSearching {
            return searchResponse?.task_app_list
        } else {
            return response?.task_app_list
        }
    }
}

extension TaskStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TaskStore") as? TaskStoreCell
        if cell == nil {
            cell = TaskStoreCell(style: .default, reuseIdentifier: "TaskStore")
        }
        
        let app = self.appList?[indexPath.row]
        cell?.app = app

        cell?.downloadButton.tag = indexPath.row
        if cell?.downloadButton.allTargets.count == 0 {
            cell?.downloadButton.addTarget(self, action: #selector(download(_:)), for: .touchUpInside)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let app = self.appList?[indexPath.row]
        return TaskStoreViewModel.rowHeight(of: app)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TaskAppDetailViewController()
        vc.app = self.appList?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TaskStoreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        searchBar.setShowsCancelButton(true, animated: true)
        table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchResponse = nil
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRequest(str: searchText)
    }
}
