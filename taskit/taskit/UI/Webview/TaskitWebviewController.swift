//
//  TaskitWebviewController.swift
//  taskit
//
//  Created by xieran on 2018/8/21.
//  Copyright © 2018年 Snow. All rights reserved.
//

import Foundation
import WebKit

class TaskitWebviewController: BaseViewController {
    lazy var webview: TaskitWebview = {
        let w = TaskitWebview()
        w.delegate = self
        w.backgroundColor = .white
        return w
    }()
    
    init(urlString: String) {
        super.init(nibName: nil, bundle: nil)
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        webview.scalesPageToFit = true
        webview.loadRequest(URLRequest(url: url))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tracker.viewTrack("Webview Controller")
    }
}

extension TaskitWebviewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        view.makeToastActivity(.center)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        view.hideToastActivity()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        view.hideToastActivity()
        view.makeToast((error as NSError).domain)
    }
}
