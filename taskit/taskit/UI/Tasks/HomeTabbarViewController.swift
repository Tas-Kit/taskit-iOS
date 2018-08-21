//
//  HomeTabbarViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/20.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class HomeTabbarViewController: BaseTabbarController {

    lazy var leftItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.size.width / 2
        button.backgroundColor = TaskitColor.profileBackground
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.addTarget(self, action: #selector(userCenter), for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }()
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let vc1 = TodoListViewController()
        vc1.tabBarItem.title = LocalizedString("待办清单")
        vc1.tabBarItem.image = #imageLiteral(resourceName: "tab_todo_normal")
        vc1.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_todo_sel")
        
        let vc2 = HomeViewController()
        vc2.tabBarItem.title = LocalizedString("主页")
        vc2.tabBarItem.image = #imageLiteral(resourceName: "tab_home_normal")
        vc2.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_home_sel")
        
        let vc3 = TaskStoreViewController()
        vc3.tabBarItem.title = LocalizedString("任务商店")
        vc3.tabBarItem.image = #imageLiteral(resourceName: "tab_store_normal")
        vc3.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_store_sel")
        
        self.viewControllers = [vc1, vc2, vc3]
        self.viewControllers?.forEach({ (vc) in
            vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = leftItem
        (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(usernameFirstLetter(), for: .normal)
        navigationItem.rightBarButtonItem = rightItem

        tabBar.tintColor = TaskitColor.navigation
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

    @objc func userCenter() {
        self.navigationController?.pushViewController(UserCenterViewController(), animated: true)
    }
    
    @objc func showNotification() {
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    @objc func updateNotiBadge() {
        self.notiBadge.text = "\(NotificationManager.notifications.count)"
        if NotificationManager.notifications.count > 0, navigationController?.topViewController == self {
            self.notiBadge.isHidden = false
        } else {
            self.notiBadge.isHidden = true
        }
    }
}
