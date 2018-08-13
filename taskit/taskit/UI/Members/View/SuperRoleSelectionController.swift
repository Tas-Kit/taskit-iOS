//
//  SuperRoleSelectionController.swift
//  taskit
//
//  Created by xieran on 2018/8/13.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class SuperRoleSelectionController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var selectBlock: ((_ superRole: SuperRole) -> Void)?
    var selections = [SuperRole.owner, SuperRole.admin, SuperRole.standard]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.estimatedSectionFooterHeight = 0
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(64)
        }
        
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        bar.backgroundColor = TaskitColor.navigation
        view.addSubview(bar)
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.frame = CGRect(x: 10, y: 35, width: 15, height: 15)
        closeBtn.setBackgroundImage(#imageLiteral(resourceName: "close_white"), for: .normal)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        bar.addSubview(closeBtn)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SuperRole")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SuperRole")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.text = selections[indexPath.row].descString
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectBlock?(selections[indexPath.row])
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
