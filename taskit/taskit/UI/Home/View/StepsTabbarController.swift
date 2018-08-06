//
//  StepsTabbarController.swift
//  taskit
//
//  Created by xieran on 2018/8/2.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class StepsTabbarController: BaseTabbarController {

    var tid: String?
    let vc1 = StepViewController(status: .finished)
    let vc2 = StepViewController(status: .inProgress)
    let vc3 = StepViewController(status: .notBegin)
    
    deinit {
        StepService.steps.removeAll()
    }
    
    init(tid: String?) {
        self.tid = tid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setViewControllers([vc1, vc2, vc3], animated: false)
  
        requestData()
    }
    
    func requestData() {
        view.makeToastActivity(.center)
        NetworkManager.request(apiPath: NetworkApiPath.graph.rawValue + (tid ?? ""), method: .get, params: nil, success: { (msg, dic) in
            self.view.hideToastActivity()
            let response = StepResponse(JSON: dic ?? [:])
            StepService.steps.removeAll()
            if let steps = response?.steps {
                StepService.steps.append(contentsOf: steps)
            }
            
            self.setTabbarItemNum()
            
            NotificationCenter.default.post(name: .kDidGetSteps, object: nil)
        }) { (code, msg, dic) in
            StepService.steps.removeAll()
            NotificationCenter.default.post(name: .kDidGetSteps, object: nil)
            self.view.hideToastActivity()
        }
    }
    
    func setTabbarItemNum() {
        let num1 = StepService.contentsOf([.completed, .skipped]).count
        let num2 = StepService.contentsOf([.inProgress, .readyForReview]).count
        let num3 = StepService.contentsOf([.new]).count
        
        let numbers = [num1, num2, num3]
        
        let font = UIFont.systemFont(ofSize: 10)
        let size = CGSize(width: UIScreen.main.bounds.width / 3, height: 40)
        
        for (index, controller) in (self.viewControllers?.enumerated())! {
            let image = imageWithNumber(numbers[index], size: size, font: font)
            controller.tabBarItem.image = image
            controller.tabBarItem.selectedImage = image
        }

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
