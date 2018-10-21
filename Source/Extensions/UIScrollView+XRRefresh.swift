//
//  UIScrollView+XRRefresh.swift
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


import Foundation
import UIKit
import WebKit

private var kRefreshHeaderViewAssociatedKey: String = "kRefreshHeaderViewAssociatedKey"
private var kRefreshFooterViewAssociatedKey: String = "kRefreshFooterViewAssociatedKey"

/// Extension for XRRefresh
extension UIScrollView {
    
    var refreshHeaderView: XRBaseRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &kRefreshHeaderViewAssociatedKey) as? XRBaseRefreshHeader
        }
        
        set {
            objc_setAssociatedObject(self, &kRefreshHeaderViewAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var refreshFooterView: XRBaseRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &kRefreshFooterViewAssociatedKey) as? XRBaseRefreshFooter
        }
        
        set {
            objc_setAssociatedObject(self, &kRefreshFooterViewAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

// MARK: - Provider for UIScrollView.
public extension XR where Base: UIScrollView {
    
    /// MARK: - Pull to refreshing
    // heightForFooter: 真正的refreshHeaderView显示的高度
    // ignoreTopHeight: 忽略的刷新头部高度，用来适配iPhoneX, XS, XR, XS Max机型
    public func addPullToRefreshHeader(refreshHeader: XRBaseRefreshHeader,
                                       heightForHeader: CGFloat = 70,
                                       ignoreTopHeight: CGFloat = 0,
                                       refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        self.base.refreshHeaderView?.removeFromSuperview()
        
        self.base.superview?.setNeedsLayout()
        self.base.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.base.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshHeader.ignoreTopHeight = ignoreTopHeight
        refreshHeader.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForHeader + ignoreTopHeight)
        
        self.base.refreshHeaderView = refreshHeader
        self.base.refreshHeaderView?.refreshingClosure = refreshClosure
        self.base.addSubview(self.base.refreshHeaderView!)
    }
    
    // auto refresh for header.
    public func beginHeaderRefreshing() {
        
        DispatchQueue.main.async {
            self.base.setContentOffset(CGPoint.zero, animated: false)
            self.base.refreshHeaderView?.beginRefreshing()
        }
    }
    
    // end refresh for header.
    public func endHeaderRefreshing() {
        
        self.base.refreshHeaderView?.endRefreshing()
    }
    
    /// MARK: - Pull to loading more
    // heightForFooter: 真正的refreshFooterView显示的高度
    // ignoreBottomHeight: 忽略的刷新底部高度，用来适配iPhoneX, XS, XR, XS Max机型
    public func addPullToRefreshFooter(refreshFooter: XRBaseRefreshFooter,
                                       heightForFooter: CGFloat = 60,
                                       ignoreBottomHeight: CGFloat = XRRefreshMarcos.xr_BottomIndicatorHeight,
                                     refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        // remove last refreshFooter
        self.base.refreshFooterView?.removeFromSuperview()
        
        self.base.superview?.setNeedsLayout()
        self.base.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.base.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshFooter.ignoreBottomHeight = ignoreBottomHeight
        refreshFooter.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForFooter + ignoreBottomHeight)
        
        self.base.refreshFooterView = refreshFooter
        self.base.refreshFooterView?.refreshingClosure = refreshClosure
        self.base.addSubview(self.base.refreshFooterView!)
    }
    
    // To end the bottom refresh method, be sure to finish the refresh after
    // the TableView or CollectionView reloadData is loaded
    public func endFooterRefreshing() {
        
        self.base.refreshFooterView?.endRefreshing()
    }
    
    // End refresh, bottom display no more data
    public func endFooterRefreshingWithNoMoreData() {
        
        self.base.refreshFooterView?.endRefreshingWithNoMoreData()
    }
    
    // End refresh, data load failed, click reload more
    public func endFooterRefreshingWithLoadingFailure() {
        
        self.base.refreshFooterView?.endRefreshingWithLoadingFailure()
    }
    
    // The refresh ends, the data is all loaded, and the footerRefresh is removed
    public func endFooterRefreshingWithRemoveLoadingMoreView() {
        
        self.base.refreshFooterView?.removeLoadMoreRefreshing()
    }
    
}

// MARK: - Provider for WKWebView
public extension XR where Base: WKWebView {
    
    /// MARK: - Pull to refreshing
    // heightForFooter: 真正的refreshHeaderView显示的高度
    // ignoreTopHeight: 忽略的刷新头部高度，用来适配iPhoneX, XS, XR, XS Max机型
    public func addPullToRefreshHeader(refreshHeader: XRBaseRefreshHeader,
                                       heightForHeader: CGFloat = 70,
                                       ignoreTopHeight: CGFloat = 0,
                                       refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        self.base.scrollView.refreshHeaderView?.removeFromSuperview()
        
        self.base.scrollView.superview?.setNeedsLayout()
        self.base.scrollView.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.base.scrollView.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshHeader.ignoreTopHeight = ignoreTopHeight
        refreshHeader.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForHeader + ignoreTopHeight)
        
        self.base.scrollView.refreshHeaderView = refreshHeader
        self.base.scrollView.refreshHeaderView?.refreshingClosure = refreshClosure
        self.base.scrollView.addSubview(self.base.scrollView.refreshHeaderView!)
    }
    
    // auto refresh for header.
    public func beginHeaderRefreshing() {
        
        DispatchQueue.main.async {
            self.base.scrollView.setContentOffset(CGPoint.zero, animated: false)
            self.base.scrollView.refreshHeaderView?.beginRefreshing()
        }
    }
    
    // end refresh for header.
    public func endHeaderRefreshing() {
        
        self.base.scrollView.refreshHeaderView?.endRefreshing()
    }
    
}

// MARK: - Provider for WKWebView
extension XR where Base: UIWebView {
    
    /// MARK: - Pull to refreshing
    // heightForFooter: 真正的refreshHeaderView显示的高度
    // ignoreTopHeight: 忽略的刷新头部高度，用来适配iPhoneX, XS, XR, XS Max机型
    public func addPullToRefreshHeader(refreshHeader: XRBaseRefreshHeader,
                                       heightForHeader: CGFloat = 70,
                                       ignoreTopHeight: CGFloat = 0,
                                       refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        self.base.scrollView.refreshHeaderView?.removeFromSuperview()
        
        self.base.scrollView.superview?.setNeedsLayout()
        self.base.scrollView.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.base.scrollView.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshHeader.ignoreTopHeight = ignoreTopHeight
        refreshHeader.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForHeader + ignoreTopHeight)
        
        self.base.scrollView.refreshHeaderView = refreshHeader
        self.base.scrollView.refreshHeaderView?.refreshingClosure = refreshClosure
        self.base.scrollView.addSubview(self.base.scrollView.refreshHeaderView!)
    }
    
    // auto refresh for header.
    public func beginHeaderRefreshing() {
        
        DispatchQueue.main.async {
            self.base.scrollView.setContentOffset(CGPoint.zero, animated: false)
            self.base.scrollView.refreshHeaderView?.beginRefreshing()
        }
    }
    
    // end refresh for header.
    public func endHeaderRefreshing() {
        
        self.base.scrollView.refreshHeaderView?.endRefreshing()
    }
}



