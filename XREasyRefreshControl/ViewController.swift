//
//  ViewController.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/7/11.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var dataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "首页"
        
        if #available(iOS 11, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        for index in 0 ..< 10 {
            dataArray.append("\(index)")
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.frame = CGRect(x: 0, y: XR_NavigationBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - XR_NavigationBarHeight - 49 - (iSiPhoneX() ? 34 : 0))
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        let headerVw = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        headerVw.backgroundColor = UIColor.gray
        mainTableView.tableHeaderView = headerVw
        
        let footerVw = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        footerVw.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        mainTableView.tableFooterView = footerVw
        
        mainTableView.xr.addPullToRefreshWithRefreshHeader(refreshHeader: XRCircleAnimatorRefreshHeader(), heightForHeader: 65) {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.dataArray.removeAll()
                for index in 0 ..< 10 {
                    self.dataArray.append("\(index)")
                }
                self.mainTableView.reloadData()
                self.mainTableView.xr.endHeaderRefreshing()
                
                self.mainTableView.xr.addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRActivityRefreshFooter(), heightForFooter: 55) {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                        for index in 0 ..< 5 {
                            self.dataArray.append("\(index)")
                        }
                        self.mainTableView.reloadData()
                        self.mainTableView.xr.endFooterRefreshing()
                    })
                }
            })
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainTableView.xr.beginHeaderRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCellIdentifier")
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }


}

