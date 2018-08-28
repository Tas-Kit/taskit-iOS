//
//  BaseViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/1.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol {
    var pageAlias: String {get}
}

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, BaseViewControllerProtocol {
    var supportPopGesture = true
    var pageAlias: String {
        return "unknown"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = leftItem()
        
        view.backgroundColor = TaskitColor.screenBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = TaskitColor.navigation
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: Constants.navigationTitleFont]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = supportPopGesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        Tracker.viewTrack(pageAlias, controller: self)
    }
    
    func leftItem(tintColor: UIColor = .white) -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        button.tintColor = tintColor
        button.setImage(#imageLiteral(resourceName: "nav_back_white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(tintColor, for: .normal)
        button.setTitle(LocalizedString("返回"), for: .normal)
        button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }
    
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
