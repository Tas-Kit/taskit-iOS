//
//  ViewController.swift
//  taskit
//
//  Created by Snow on 2018/7/11.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getJwt(_ sender: Any) {
        Alamofire.request("http://sandbox.tas-kit.com/api/v1/userservice/exempt/get_jwt/", method: .post, parameters: ["username":"Snow","password":"asd123456."]).responseJSON(completionHandler: { (response) in
            if let json = response.result.value as? [String:Any]{
                print(json["token"] as! String)
            }
        })
    }
    
}

