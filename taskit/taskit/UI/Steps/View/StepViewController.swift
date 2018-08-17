//
//  StepViewController.swift
//  taskit
//
//  Created by xieran on 2018/8/2.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import SnapKit

class StepViewController: BaseViewController {
    enum StepListStatus {
        case finished
        case inProgress
        case notBegin
    }
    
    var status: StepListStatus?
    var sections = [StepSection]()
    var stepResponse: StepResponse?
    
    var tid: String?
    lazy var table: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.rowHeight = 50
        return t
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(status: StepListStatus) {
        super.init(nibName: nil, bundle: nil)
        
        self.status = status
        switch status {
        case .finished:
            self.tabBarItem.title = LocalizedString("已完成")
            sections = [StepSection(stepStatus: .completed), StepSection(stepStatus: .skipped)]
        case .inProgress:
            self.tabBarItem.title = LocalizedString("进行中")
            sections = [StepSection(stepStatus: .inProgress), StepSection(stepStatus: .readyForReview)]
        case .notBegin:
            self.tabBarItem.title = LocalizedString("未开始")
            sections = [StepSection(stepStatus: .new)]

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.es.addPullToRefresh {
            StepService.requestSteps(tid: (self.tabBarController as? StepsTabbarController)?.task?.task?.tid)
        }
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        didGetStepList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetStepList), name: .kDidGetSteps, object: nil)
    }
    
    @objc func didGetStepList() {
        table.es.stopPullToRefresh()
        
        for index in 0..<sections.count {
            let section = sections[index]
            section.steps.removeAll()
            for step in StepService.steps where step.status == section.stepStatus {
                section.steps.append(step)
            }
        }        
        table.reloadData()
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

extension StepViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = sections[section]
        return sectionModel.steps.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Step")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Step")
            cell?.backgroundColor = .white
            cell?.textLabel?.textColor = TaskitColor.majorText
            cell?.textLabel?.textAlignment = .left
            cell?.separatorInset = .zero
            cell?.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        
        let section = sections[indexPath.section]
        let step = section.steps[indexPath.row]
        
        cell?.textLabel?.text = "   " + (step.name ?? "")
        
        cell?.imageView?.image = UIImage(named: "step_" + (step.status?.rawValue ?? "default"))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = sections[section]
        return model.height
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sections[section]
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: model.height))
        label.text = "      \(model.title)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = model.backgroundColor
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        let step = section.steps[indexPath.row]
        let vc = StepDetailViewController(step, color: section.backgroundColor)
        vc.tid = self.tid
        vc.stepResponse = stepResponse
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
