
//
//  UIScrollView+XRRefresh.swift
//  XRRefresh
//
//  Created by 徐冉 on 2018/6/20.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import Foundation
import UIKit

private var kRefreshHeaderViewAssociatedKey: String = "kRefreshHeaderViewAssociatedKey"
private var kRefreshFooterViewAssociatedKey: String = "kRefreshFooterViewAssociatedKey"

// Extension for XRRefresh
extension UIScrollView {
    
    private var refreshHeaderView: XRBaseRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &kRefreshHeaderViewAssociatedKey) as? XRBaseRefreshHeader
        }
        
        set {
            objc_setAssociatedObject(self, &kRefreshHeaderViewAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var refreshFooterView: XRBaseRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &kRefreshFooterViewAssociatedKey) as? XRBaseRefreshFooter
        }
        
        set {
            objc_setAssociatedObject(self, &kRefreshFooterViewAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// MARK: - Pull to refreshing
    func addPullToRefreshWithRefreshHeader(refreshHeader: XRBaseRefreshHeader, heightForHeader: CGFloat = 70, refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        self.refreshHeaderView?.removeFromSuperview()
        
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshHeader.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForHeader)
        self.refreshHeaderView = refreshHeader
        self.refreshHeaderView?.refreshingClosure = refreshClosure
        self.addSubview(refreshHeaderView!)
    }
    
    // 手动下拉刷新
    func beginHeaderRefreshing() {
        
        self.refreshHeaderView?.beginRefreshing()
    }
    
    // 结束下拉刷新
    func endHeaderRefreshing() {
        
        self.refreshHeaderView?.endRefreshing()
    }
    
    // MARK: - Pull to loading more
    func addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRBaseRefreshFooter, heightForFooter: CGFloat = 55, refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        // remove last refreshFooter
        self.refreshFooterView?.removeFromSuperview()
        
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshFooter.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForFooter)
        self.refreshFooterView = refreshFooter
        self.refreshFooterView?.refreshingClosure = refreshClosure
        self.addSubview(refreshFooterView!)
    }
    
    // 结束底部刷新方法，请务必在数据加载完成后TableView or CollectionView reloadData之后结束刷新
    func endFooterRefreshing() {
        
        self.refreshFooterView?.endRefreshing()
    }
    
    // 结束刷新，底部显示没有更多数据了
    func endFooterRefreshingWithNoMoreData() {
        
        self.refreshFooterView?.endRefreshingWithNoMoreData()
    }
    
    // 结束刷新，数据加载失败了，点击重新加载更多
    func endFooterRefreshingWithLoadingFailure() {
        
        self.refreshFooterView?.endRefreshingWithLoadingFailure()
    }
    
    // 结束刷新，数据全部加载完毕了，移除footerRefresh
    func endFooterRefreshingWithRemoveLoadingMoreView() {
        
        self.refreshFooterView?.removeLoadMoreRefreshing()
    }
    
}

// Extension for contentInset
extension UIScrollView {
    
    var xr_contentInset: UIEdgeInsets {
        get {
            return self.contentInset
        }
        
        set {
            self.contentInset = newValue
        }
    }
    
    var xr_contentInsetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom = inset.bottom - (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
    }
    
    var xr_contentInsetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top = inset.top - (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }
    
    var xr_contentHeight: CGFloat {
        get {
            return self.contentSize.height
        }
        
        set {
            var contentSize = self.contentSize
            contentSize.height = newValue
            self.contentSize = contentSize
        }
    }
    
}

