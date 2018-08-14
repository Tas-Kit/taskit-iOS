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
            
            model?.users = model?.users?.filter({ (user) -> Bool in
                return user.has_task?.acceptance == Acceptance.accept
            })
            
        }
    }
    var mySuperRole: SuperRole?
    
    lazy var inviteView: InvitationView = {
        let v = InvitationView()
        v.inviteBlock = {[unowned self](name) in
            self.invite(name)
        }
        return v
    }()
    
    lazy var table: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.allowsSelection = false
        t.separatorStyle = .none
        t.estimatedRowHeight = 0
        t.estimatedSectionHeaderHeight = 0
        t.estimatedSectionFooterHeight = 0
        t.register(UINib.init(nibName: "MemberCell", bundle: nil), forCellReuseIdentifier: "MemberCell")
        t.es.addPullToRefresh {
            StepService.requestSteps(tid: self.model?.taskInfo?.tid)
        }
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = LocalizedString("成员")
        view.backgroundColor = .white

        view.addSubview(inviteView)
        inviteView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(inviteView.snp.bottom).offset(20)
        }

        mySuperRole = SuperRoleManager.superRole(of: self.model)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetStepList), name: .kDidGetSteps, object: nil)
    }
    
    func presentSuperRoleSelection(roleType: RoleType, userIndex: Int) {
        switch roleType {
        //SuperRole
        case .superRole:
            let vc = SuperRoleSelectionController()
            vc.selectBlock = {[weak self](selIndex) in
                if let user = self?.model?.users?[userIndex] {
                    let superRole = vc.superRoles[selIndex]
                    self?.changeSuperRole(superRole, user: user)
                }
            }
            present(vc, animated: true, completion: nil)
        //Role
        case .role:
            let vc = RoleSelectionViewController()
            vc.roles = model?.taskInfo?.roles
            vc.selectBlock = {[weak self](selIndex) in
                if let role = vc.roles?[selIndex], let user = self?.model?.users?[userIndex] {
                    self?.changeRole(role: role, user: user)
                }
            }
            present(vc, animated: true, completion: nil)
        }
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
        cell.selectRole = {[unowned self](roleType) in
            self.presentSuperRoleSelection(roleType: roleType, userIndex: indexPath.row)
        }
        
        cell.rejectBlock = {[weak self] in
            self?.rejectRequest(index: indexPath.row)
        }
        
        if mySuperRole == SuperRole.owner {
            if user?.has_task?.super_role == SuperRole.owner {
                cell.superRoleTf.isEnabled = false
                cell.superRoleTf.textColor = .lightGray
            } else {
                cell.superRoleTf.isEnabled = true
                cell.superRoleTf.textColor = TaskitColor.majorText
            }
        } else {
            cell.superRoleTf.isEnabled = false
            cell.superRoleTf.textColor = .lightGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        self.model = notice.object as? StepResponse
        self.table.es.stopPullToRefresh()
        self.table.reloadData()
    }
}

///Invite & Reject
extension MemberViewController {
    func invite(_ name: String) {
        guard !name.isEmpty else {
            return
        }
        inviteView.endEditing(true)
        //invite
        view.makeToastActivity(.center)
        NetworkManager.request(urlString: NetworkApiPath.invitaiton.rawValue + (model?.taskInfo?.tid ?? "") + "/", method: .post, params: ["username": name], success: { (msg, dic) in
            self.view.hideToastActivity()
            //success
            InviteSuccessView.show()
            self.inviteView.nameTf.text = nil
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("邀请失败"))
        }
    }
    
    func rejectRequest(index: Int) {
        if let user = model?.users?[index] {
            view.makeToastActivity(.center)
            NetworkManager.request(urlString: NetworkApiPath.revoke.rawValue + (model?.taskInfo?.tid ?? "") + "/", method: .post, params: ["uid": user.basic?.uid ?? ""], success: { (msg, dic) in
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
        NetworkManager.request(urlString: NetworkApiPath.changeRole.rawValue + (model?.taskInfo?.tid ?? "") + "/", method: .post, params: ["superRole": superRole.rawValue, "uid": user.basic?.uid ?? ""], success: { (msg, dic) in
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
        NetworkManager.request(urlString: NetworkApiPath.changeRole.rawValue + (model?.taskInfo?.tid ?? "") + "/", method: .post, params: ["role": role, "uid": user.basic?.uid ?? ""], success: { (msg, dic) in
            self.view.hideToastActivity()
            
            user.has_task?.role = role
            self.table.reloadData()
        }) { (code, msg, dic) in
            self.view.hideToastActivity()
            self.view.makeToast(LocalizedString("Operation Failed"))
        }
    }
    
}

