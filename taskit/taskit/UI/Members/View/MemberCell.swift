//
//  MemberCell.swift
//  taskit
//
//  Created by xieran on 2018/8/12.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var superRoleTf: UITextField!
    @IBOutlet weak var roleTf: UITextField!
    @IBOutlet weak var rejectBtn: UIButton!

    var downBtn: UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "menu_down"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        return btn
    }
    
    var userModel: UserResponse? {
        didSet {
            nameLabel.text = userModel?.basic?.username
            superRoleTf.text = userModel?.has_task?.super_role?.descString
            roleTf.text = userModel?.has_task?.role
            
            rejectBtn.isEnabled = userModel?.has_task?.super_role == SuperRole.owner ? false : true
            
            
        }
    }
    
    var selectRole: ((_ roleType: RoleType) -> Void)?
    var rejectBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        superRoleTf.rightViewMode = .always
        superRoleTf.rightView = downBtn
        
        roleTf.rightViewMode = .always
        roleTf.rightView = downBtn
        
        let line1 = UIView()
        line1.backgroundColor = TaskitColor.majorText
        addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(superRoleTf)
            make.height.equalTo(0.5)
            make.top.equalTo(superRoleTf.snp.bottom).offset(2)
        }
        
        let line2 = UIView()
        line2.backgroundColor = TaskitColor.majorText
        addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.right.equalTo(roleTf)
            make.height.equalTo(0.5)
            make.top.equalTo(roleTf.snp.bottom).offset(2)
        }
    }
  
    @IBAction func reject() {
        rejectBlock?()
    }
}

extension MemberCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == superRoleTf {
            selectRole?(.superRole)
        } else if textField == roleTf {
            selectRole?(.role)
        }
        return false
    }
}
