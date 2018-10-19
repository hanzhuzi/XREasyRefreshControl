//
//  ExampleCollectionViewController.swift
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

class ExampleCollectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {

    private var mainCollectionVw: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.estimatedItemSize = .zero
        
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let itemWidth: CGFloat = (UIScreen.main.bounds.size.width - 25) / 4.0
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionVw = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return collectionVw
    }()
    
    private var dataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(mainCollectionVw)
        mainCollectionVw.backgroundColor = UIColor.white
        mainCollectionVw.frame = CGRect(x: 0, y: XR_NavigationBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - XR_NavigationBarHeight)
        
        mainCollectionVw.delegate = self
        mainCollectionVw.dataSource = self
        mainCollectionVw.alwaysBounceVertical = true
        
        mainCollectionVw.register(ExampleCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "ExampleCollectionViewCell")
        
        // 添加下拉刷新
        mainCollectionVw.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader()) { [weak self] in
            if let weakSelf = self {
                weakSelf.requestForData(isRefresh: true, isPullToHeaderRefresh: true)
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 自动下拉刷新
        mainCollectionVw.xr.beginHeaderRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainCollectionVw.xr.endHeaderRefreshing()
        mainCollectionVw.xr.endFooterRefreshing()
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
                
                for _ in 0 ..< 10 {
                    weakSelf.dataArray.append("--")
                }
                
                weakSelf.mainCollectionVw.reloadData()
                weakSelf.mainCollectionVw.xr.endHeaderRefreshing()
                weakSelf.mainCollectionVw.xr.endFooterRefreshing()
                
                if weakSelf.dataArray.count > 0 {
                    // 添加上拉加载更多
                    weakSelf.mainCollectionVw.xr.addPullToRefreshFooter(refreshFooter: CustomActivityRefreshFooter(), heightForFooter: 55 + XR_MainIndicatorBottomHeight, refreshingClosure: {
                        weakSelf.requestForData(isRefresh: false, isPullToHeaderRefresh: true)
                    })
                }
                
                // 服务端数据全部加载完毕时
                if weakSelf.dataArray.count >= 40 {
                    // 显示无更多数据了
                    weakSelf.mainCollectionVw.xr.endFooterRefreshingWithNoMoreData()
//                    // 结束刷新，并移除loadingFooter
//                    weakSelf.mainCollectionVw.xr.endFooterRefreshingWithRemoveLoadingMoreView()
//                    // 加载失败
//                    weakSelf.mainCollectionVw.xr.endFooterRefreshingWithLoadingFailure()
                }
                
            }
        })
    }
    
    // MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCollectionViewCell", for: indexPath) as! ExampleCollectionViewCell
        
        cell.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random() % 255) / 255.0), green: CGFloat(CGFloat(arc4random() % 255) / 255.0), blue: CGFloat(CGFloat(arc4random() % 255) / 255.0), alpha: 1.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}
