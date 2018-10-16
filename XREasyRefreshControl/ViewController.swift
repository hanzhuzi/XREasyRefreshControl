//
//  ViewController.swift
//
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
        
        // MARK: - 添加下拉刷新，上拉加载
        mainTableView.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader(), heightForHeader: 65) { [weak self] in
            
            if let weakSelf = self {
                // 请求模拟
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    weakSelf.dataArray.removeAll()
                    for index in 0 ..< 10 {
                        weakSelf.dataArray.append("\(index)")
                    }
                    
                    weakSelf.mainTableView.reloadData()
                    weakSelf.mainTableView.xr.endHeaderRefreshing()
                    weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: CustomActivityRefreshFooter(), heightForFooter: 55) {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                            for index in 0 ..< 5 {
                                weakSelf.dataArray.append("\(index)")
                            }
                            weakSelf.mainTableView.reloadData()
                            weakSelf.mainTableView.xr.endFooterRefreshing()
                        })
                    }
                })
            }
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

