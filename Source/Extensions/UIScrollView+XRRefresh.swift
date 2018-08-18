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

/// Provider for UIScrollView.
public extension XR where Base: UIScrollView {
    
    /// MARK: - Pull to refreshing
    public func addPullToRefreshWithRefreshHeader(refreshHeader: XRBaseRefreshHeader, heightForHeader: CGFloat = 70, refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        self.base.refreshHeaderView?.removeFromSuperview()
        
        self.base.superview?.setNeedsLayout()
        self.base.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.base.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshHeader.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForHeader)
        self.base.refreshHeaderView = refreshHeader
        self.base.refreshHeaderView?.refreshingClosure = refreshClosure
        self.base.addSubview(self.base.refreshHeaderView!)
    }
    
    // auto refresh for header.
    public func beginHeaderRefreshing() {
        
        self.base.refreshHeaderView?.beginRefreshing()
    }
    
    // end refresh for header.
    public func endHeaderRefreshing() {
        
        self.base.refreshHeaderView?.endRefreshing()
    }
    
    /// MARK: - Pull to loading more
    public func addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRBaseRefreshFooter, heightForFooter: CGFloat = 55, refreshingClosure refreshClosure:@escaping (() -> Swift.Void)) {
        
        // remove last refreshFooter
        self.base.refreshFooterView?.removeFromSuperview()
        
        self.base.superview?.setNeedsLayout()
        self.base.superview?.layoutIfNeeded()
        
        var scrollViewWidth: CGFloat = self.base.bounds.size.width
        if scrollViewWidth <= 0 {
            scrollViewWidth = XRRefreshControlSettings.sharedSetting.screenSize.width
        }
        
        refreshFooter.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: heightForFooter)
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
    
    var xr_contentOffsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        
        set {
            var contentOffSet_ = self.contentOffset
            contentOffSet_.y = newValue
            self.contentOffset = contentOffSet_
        }
    }
    
}

