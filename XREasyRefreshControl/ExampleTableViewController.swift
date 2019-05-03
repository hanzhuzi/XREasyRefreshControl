//
//  ExampleTableViewController.swift
//  Copyright (c) 2018 - 2020 Ran Xu
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class ExampleTableViewController: UIViewController {

    var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var dataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        for index in 0 ..< 10 {
            dataArray.append("tableViewCell->\(index)")
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.frame = CGRect(x: 0, y: XRRefreshMarcos.xr_StatusBarHeight + XRRefreshMarcos.xr_navigationBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - XRRefreshMarcos.xr_StatusBarHeight - XRRefreshMarcos.xr_navigationBarHeight)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.estimatedRowHeight = 0
        mainTableView.estimatedSectionFooterHeight = 0
        mainTableView.estimatedSectionHeaderHeight = 0
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        let headerVw = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        headerVw.backgroundColor = UIColor.gray
        mainTableView.tableHeaderView = headerVw
        
        let footerVw = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        footerVw.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        mainTableView.tableFooterView = footerVw
        
        // 添加下拉刷新
        mainTableView.xr.addPullToRefreshHeader(refreshHeader: XRImageRefreshHeader(), heightForHeader: 65) { [weak self] in
            
            if let weakSelf = self {
                weakSelf.requestForData(isRefresh: true, isPullToHeaderRefresh: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainTableView.xr.beginHeaderRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainTableView.xr.endHeaderRefreshing()
        mainTableView.xr.endFooterRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Request
    // 请求模拟
    func requestForData(isRefresh: Bool, isPullToHeaderRefresh: Bool) {
        
        if !isPullToHeaderRefresh {
            // show loading indicator...
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { [weak self] in
            if let weakSelf = self {
                
                if isRefresh {
                    weakSelf.dataArray.removeAll()
                }
                
                for index in 0 ..< 30 {
                    weakSelf.dataArray.append("tableViewCell->\(index)")
                }
                
                weakSelf.mainTableView.reloadData()
                weakSelf.mainTableView.xr.endHeaderRefreshing()
                weakSelf.mainTableView.xr.endFooterRefreshing()
                
                if weakSelf.dataArray.count > 0 {
                    // 添加上拉加载更多
                    weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: XRImageRefreshFooter(), heightForFooter: 60, refreshingClosure: {
                        weakSelf.requestForData(isRefresh: false, isPullToHeaderRefresh: true)
                    })
                }
                
                // 服务端数据全部加载完毕时
                if weakSelf.dataArray.count >= 120 {
                    // 显示无更多数据了
//                    weakSelf.mainTableView.xr.endFooterRefreshingWithNoMoreData()
                    //                    // 结束刷新，并移除loadingFooter
                    //                    weakSelf.mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()
                    //                    // 加载失败
                                        weakSelf.mainTableView.xr.endFooterRefreshingWithLoadingFailure()
                }
                
            }
        })
    }
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension ExampleTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "UITableViewCellIdentifier")
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let exmplaCtrl = ExampleNavHiddenViewController()
        self.navigationController?.pushViewController(exmplaCtrl, animated: true)
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




