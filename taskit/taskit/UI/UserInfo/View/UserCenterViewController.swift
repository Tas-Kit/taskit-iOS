//
//  UserCenterViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/2.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController {

    let titles = [[LocalizedString("邮箱") + ":"],
                  [LocalizedString("即时通知")],
                  [LocalizedString("帮助&反馈"), LocalizedString("服务条款")]]
    let sectionTitles = [LocalizedString("账户"),
                         LocalizedString("设置"),
                         LocalizedString("关于产品")]
    
    lazy var table: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.rowHeight = 60
        return t
    }()
    
    lazy var avatar: UILabel = {
        let av = UILabel()
        av.backgroundColor = TaskitColor.profileBackground
        av.textColor = .white
        av.textAlignment = .center
        av.layer.masksToBounds = true
        av.layer.cornerRadius = 25
        av.text = usernameFirstLetter()
        return av
    }()
    lazy var header: UIView = {
        let h = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        h.addSubview(avatar)
        avatar.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        })
        return h
    }()
    
    lazy var footer: UIView = {
        let f = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let btn = UIButton(type: .custom)
        btn.setTitle(LocalizedString("退出登录"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = TaskitColor.button
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        f.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 100)
            make.height.equalTo(40)
        })
        
        return f
    }()
    
    var response: UserInfoResponse?
    var noticeSwitch: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = leftItem(tintColor: TaskitColor.button)
        navigationItem.title = KeychainTool.value(forKey: .username) as? String
        
        table.tableHeaderView = header
        table.tableFooterView = footer
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: TaskitColor.majorText, NSAttributedStringKey.font: Constants.navigationTitleFont]
        
        Tracker.viewTrack("User Center")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = TaskitColor.navigation
    }
    
    func requestData() {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .userInfo, method: .get, params: nil, success: { (msg, dic) in
            self.view.hideToastActivity()
            if let response = UserInfoResponse(JSON: dic) {
                self.response = response
                
                if let username = response.username {
                    KeychainTool.set(username, key: .username)
                    self.avatar.text = usernameFirstLetter()
                }
                
                self.table.reloadData()
            }
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
        }
    }
    
    @IBAction func logout() {
        LoginService.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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

extension UserCenterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCenter")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "UserCenter")
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell?.separatorInset = .zero
            cell?.selectionStyle = .none
        }
        
        let prompt = titles[indexPath.section][indexPath.row]
        cell?.textLabel?.text = prompt
        
        if indexPath.section == 0, indexPath.row == 0 {
            cell?.textLabel?.text = prompt + " " + (self.response?.email ?? "")
        } else if indexPath.section == 1, indexPath.row == 0, noticeSwitch == nil {
            noticeSwitch = UISwitch()
            noticeSwitch?.isEnabled = false
            cell?.contentView.addSubview(noticeSwitch!)
            noticeSwitch?.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-20)
            })
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserHeader")
        if header == nil {
            header = UITableViewHeaderFooterView(reuseIdentifier: "UserHeader")
            header?.textLabel?.font = UIFont.systemFont(ofSize: 20)
            header?.textLabel?.textColor = .white
            
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            v.backgroundColor = TaskitColor.accountSection
            header?.backgroundView = v
        }
        
        header?.textLabel?.text = sectionTitles[section]
        
        return header!
    }
}
