//
//  HomeViewController.swift
//  taskit
//
//  Created by xieran on 2018/7/25.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchTable: UITableView!

    var pageNum = 0
    var tasks = [TaskModel]()
    var searchResults = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("Home Page")
        navigationItem.leftBarButtonItem = leftItem()
        view.backgroundColor = TaskitColor.screenBackground
        
        if let username = KeychainTool.value(forKey: .username) as? String, !username.isEmpty {
            let firstLetter = String(username.first!).uppercased()
            (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(firstLetter, for: .normal)
        }
        
        requestData()
    }
 
    func requestData() {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .taskList, method: .get, params: nil, success: { (msg, dic) in
            self.view.hideToastActivity()
            for (_, value) in (dic ?? [:]) {
                if let dic = value as? [String: Any], let model = TaskModel(JSON: dic) {
                    self.tasks.append(model)
                }
            }
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
        }
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        var controllers = self.navigationController?.viewControllers
        controllers?.insert(LoginViewController(), at: 0)
        self.navigationController?.viewControllers = controllers!
        self.navigationController?.popToRootViewController(animated: true)
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
        return UIBarButtonItem.init(customView: button)
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
            cell?.imageView?.image = #imageLiteral(resourceName: "clipboard")
            cell?.backgroundColor = .white
        }
        
        let model = tableView == self.searchTable ? searchResults[indexPath.row] : tasks[indexPath.row]
        cell?.textLabel?.text = model.task?.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
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
