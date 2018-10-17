//
//  ExampleWKWebViewController.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/10/17.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
import WebKit

class ExampleWKWebViewController: UIViewController {

    private var wkWebVw: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = false
        let webVw = WKWebView(frame: CGRect.zero, configuration: config)
        return webVw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        wkWebVw.frame = CGRect(x: 0, y: XR_NavigationBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - XR_NavigationBarHeight)
        self.view.addSubview(wkWebVw)
        
        let request = URLRequest(url: URL(string: "https://github.com/hanzhuzi/")!)
        wkWebVw.load(request)
        
        wkWebVw.uiDelegate = self
        wkWebVw.navigationDelegate = self
        
        wkWebVw.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader()) { [weak self] in
            if let weakSelf = self {
                weakSelf.wkWebVw.reload()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        wkWebVw.xr.beginHeaderRefreshing()
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

extension ExampleWKWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        wkWebVw.xr.endHeaderRefreshing()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        wkWebVw.xr.endHeaderRefreshing()
    }
    
}

extension ExampleWKWebViewController: WKUIDelegate {
    
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}



