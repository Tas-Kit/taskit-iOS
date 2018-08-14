//
//  SuperRoleSelectionController.swift
//  taskit
//
//  Created by xieran on 2018/8/13.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class SuperRoleSelectionController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var selectBlock: ((_ index: Int) -> Void)?
    var superRoles = [SuperRole.owner, SuperRole.admin, SuperRole.standard]
    var contents = [String]()
    
    lazy var table: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.isScrollEnabled = false
        t.estimatedSectionFooterHeight = 0
        view.addSubview(t)
        t.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(64)
        }
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        bar.backgroundColor = TaskitColor.navigation
        view.addSubview(bar)
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.frame = CGRect(x: 10, y: 35, width: 15, height: 15)
        closeBtn.setBackgroundImage(#imageLiteral(resourceName: "close_white"), for: .normal)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        bar.addSubview(closeBtn)
        
        configContents()
        table.reloadData()
    }
    
    func configContents() {
        for superRole in superRoles {
            contents.append(superRole.descString)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SuperRole")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SuperRole")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.text = contents[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectBlock?(indexPath.row)
        close()
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
