//
//  MemberViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class MemberViewController: BaseViewController {
    var model: StepResponse? {
        didSet {
            model?.users?.sort(by: { (user1, user2) -> Bool in
                if let superRole1 = user1.has_task?.super_role, let superRole2 = user2.has_task?.super_role {
                    return superRole1.rawValue > superRole2.rawValue
                } else {
                    return false
                }
            })
        }
    }
    var mySuperRole: SuperRole?
    
    lazy var table: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.allowsSelection = false
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.register(UINib.init(nibName: "MemberCell", bundle: nil), forCellReuseIdentifier: "MemberCell")
        t.es.addPullToRefresh {[weak self] in
            self?.refreshData()
        }
        return t
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = LocalizedString("请输入用户名")
        bar.showsCancelButton = true
        bar.barTintColor = UIColor(hex: "F3F3F3")
        bar.delegate = self
        bar.autocapitalizationType = .none

        if let cancelBtn = bar.value(forKey: "cancelButton") as? UIButton {
            cancelBtn.setTitle(LocalizedString("邀请"), for: .normal)
            cancelBtn.setTitleColor(TaskitColor.button, for: .normal)
        }
        let searchTf = bar.value(forKey: "_searchField") as? UITextField
        searchTf?.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
        searchTf?.font = UIFont.systemFont(ofSize: 14)
        searchTf?.textColor = TaskitColor.majorText
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("成员")
        view.backgroundColor = .white

        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }

        mySuperRole = SuperRoleManager.mySuperRole(of: self.model)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetStepList), name: .kDidGetSteps, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.viewTrack("Member List")
    }
    
    func showRolePicker(roleType: RoleType, userIndex: Int) {
        switch roleType {
        //SuperRole
        case .superRole:
            let picker = SuperRolePickerView()
            picker.selection = self.model?.users?[userIndex].has_task?.super_role
            picker.selectBlock = {[unowned self](superRole) in
                if let user = self.model?.users?[userIndex] {
                    self.changeSuperRole(superRole, user: user)
                }
            }
            picker.show()
        //Role
        case .role:
            let picker = RolePickerView()
            picker.roles = self.model?.taskInfo?.roles
            picker.selection = self.model?.users?[userIndex].has_task?.role
            picker.selectBlock = {[unowned self](roleString) in
                if let role = roleString, let user = self.model?.users?[userIndex] {
                    self.changeRole(role: role, user: user)
                }
            }
            picker.show()
        }
    }
    
    func refreshData() {
        StepService.requestSteps(tid: self.model?.taskInfo?.tid)
    }
}

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as! MemberCell
        let user = model?.users?[indexPath.row]
        cell.userModel = user
        cell.selectRoleBlock = {[unowned self](roleType) in
            self.showRolePicker(roleType: roleType, userIndex: indexPath.row)
        }
        
        cell.rejectBlock = {[weak self] in
            self?.rejectRequest(index: indexPath.row)
        }
        
        //SuperRole btn enabled
        if mySuperRole == SuperRole.owner,
            (mySuperRole?.rawValue ?? 0) > (user?.has_task?.super_role?.rawValue ?? 0) {
            cell.superRoleBtn.isEnabled = true
        } else {
            cell.superRoleBtn.isEnabled = false
        }
        
        //Role btn enabled
        if (model?.taskInfo?.roles?.count ?? 0) > 0,
            (mySuperRole ?? .standard).rawValue >= (user?.has_task?.super_role ?? .standard).rawValue,
            (mySuperRole ?? .standard).rawValue > SuperRole.standard.rawValue {
            cell.roleBtn.isEnabled = true
        } else {
            cell.roleBtn.isEnabled = false
        }
        
        //reject enabled
        if (mySuperRole?.rawValue ?? 0) > (user?.has_task?.super_role?.rawValue ?? 0) {
            cell.rejectBtn.isEnabled = true
        } else {
            cell.rejectBtn.isEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension MemberViewController {
    @objc func didGetStepList(notice: Notification) {
        self.view.hideToastActivity()
        self.model = notice.object as? StepResponse
        self.table.es.stopPullToRefresh()
        self.table.reloadData()
    }
}

///Invite & Reject
extension MemberViewController {
    func invite(_ name: String?) {
        guard !(name?.isEmpty ?? true) else {
            return
        }
        view.endEditing(true)
        //invite
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .invitaiton, method: .post, additionalPath: model?.taskInfo?.tid, params: ["username": name ?? ""], success: { (msg, dic) in
            //success
            InviteSuccessView.show()
            self.searchBar.text = nil
            //refresh
            self.refreshData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("邀请失败"))
        }
    }
    
    func rejectRequest(index: Int) {
        if let user = model?.users?[index] {
            view.makeToastActivity(.center)
            NetworkManager.request(apiPath: .revoke, method: .post, additionalPath: model?.taskInfo?.tid, params: ["uid": user.basic?.uid ?? ""], success: { (msg, dic) in
                self.view.hideToastActivity()
                self.model?.users?.remove(at: index)
                self.table.reloadData()
            }) { (code, msg, dic) in
                self.view.hideToastActivity()
                
            }
        }
    }
}

///SuperRole & Role
extension MemberViewController {
    func changeSuperRole(_ superRole: SuperRole, user: UserResponse) {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .changeRole, method: .post, additionalPath: model?.taskInfo?.tid, params: ["super_role": superRole.rawValue, "uid": user.basic?.uid ?? ""], success: { (msg, dic) in
            self.view.hideToastActivity()
            user.has_task?.super_role = superRole
            //把自己的owner给了其他人
            if superRole == .owner {
                SuperRoleManager.changeSuperRole(of: self.model, superRole: .admin)
            }
            
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("操作失败"))
        }
    }
    
    func changeRole(role: String, user: UserResponse) {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: .changeRole, method: .post, additionalPath: model?.taskInfo?.tid, params: ["role": role, "uid": user.basic?.uid ?? ""], success: { (msg, dic) in
            self.view.hideToastActivity()
            
            user.has_task?.role = role
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("Operation Failed"))
        }
    }
    
}

extension MemberViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        invite(searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        invite(searchBar.text)
    }
}
