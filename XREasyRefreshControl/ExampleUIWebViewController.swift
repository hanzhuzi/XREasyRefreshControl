//
//  ExampleUIWebViewController.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/10/17.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class ExampleUIWebViewController: UIViewController {

    private var webVw: UIWebView = {
        let webVw = UIWebView(frame: CGRect.zero)
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
        
        webVw.frame = CGRect(x: 0, y: XR_NavigationBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - XR_NavigationBarHeight)
        self.view.addSubview(webVw)
        webVw.delegate = self
        
        let request = URLRequest(url: URL(string: "https://github.com/hanzhuzi/")!)
        webVw.loadRequest(request)
        
        webVw.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader()) { [weak self] in
            if let weakSelf = self {
                weakSelf.webVw.reload()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webVw.xr.beginHeaderRefreshing()
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

extension ExampleUIWebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webVw.xr.endHeaderRefreshing()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        webVw.xr.endHeaderRefreshing()
    }
}


