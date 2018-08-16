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
    @IBOutlet weak var superRoleBtn: UIButton!
    @IBOutlet weak var roleBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var acceptanceLabel: UILabel!
    @IBOutlet weak var acceptanceImg: UIImageView!

    var downBtn: UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "menu_down"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        return btn
    }
    
    var userModel: UserResponse? {
        didSet {
            nameLabel.text = userModel?.basic?.username

            if let acceptance = userModel?.has_task?.acceptance {
                switch acceptance {
                case .accept:
                    acceptanceImg.image = #imageLiteral(resourceName: "check_black")
                case .reject:
                    acceptanceImg.image = #imageLiteral(resourceName: "reject_black")
                case .waiting:
                    acceptanceImg.image = #imageLiteral(resourceName: "waiting_black")
                }
            }
            
            if let firstC = userModel?.basic?.username?.first {
                avatarLabel.text = String(firstC)
            } else {
                avatarLabel.text = nil
            }
            
            DispatchQueue.main.async {
                self.updateRoleButtons(self.userModel?.has_task?.super_role?.descString, self.userModel?.has_task?.role)
            }
        }
    }
    
    var selectRoleBlock: ((_ roleType: RoleType) -> Void)?
    var rejectBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        acceptanceLabel.text = LocalizedString("接受邀请")
        
        avatarLabel.layer.cornerRadius = avatarLabel.frame.height / 2
        superRoleBtn.layer.cornerRadius = superRoleBtn.frame.height / 2
        roleBtn.layer.cornerRadius = roleBtn.frame.height / 2
    }
  
    @IBAction func reject() {
        rejectBlock?()
    }
    
    @IBAction func selectSuperRole() {
        selectRoleBlock?(.superRole)
    }
    
    @IBAction func selectRole() {
        selectRoleBlock?(.role)
    }
    
    func updateRoleButtons(_ superRoleStr: String?, _ roleStr: String?) {
        superRoleBtn.setTitle(superRoleStr, for: .normal)
        if (roleStr?.isEmpty ?? true) {
            roleBtn.setTitle(LocalizedString("无"), for: .normal)
        } else {
            roleBtn.setTitle(roleStr, for: .normal)
        }
        
        
        let textSize1 = Tools.textSize(for: superRoleStr, font: (superRoleBtn.titleLabel?.font)!, width: 100, height: 100)
        let textSize2 = Tools.textSize(for: roleBtn.title(for: .normal), font: (superRoleBtn.titleLabel?.font)!, width: 100, height: 100)
        var frameSuper = superRoleBtn.frame
        frameSuper.size.width = textSize1.width + 30
        superRoleBtn.frame = frameSuper
        
        var frameRole = roleBtn.frame
        frameRole.size.width = textSize2.width + 30
        frameRole.origin.x = (UIScreen.main.bounds.width - frameRole.width) / 2
        roleBtn.frame = frameRole
    }
}
