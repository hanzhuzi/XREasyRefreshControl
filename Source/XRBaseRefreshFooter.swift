//
//  XRBaseRefreshFooter.swift
//  XRRefresh
//
//  Created by 徐冉 on 2018/6/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
/**
 - 上拉加载基类
 */

import UIKit
import Foundation

private let keyPathForContentOffset: String = "contentOffset"
private let keyPathForContentSize: String = "contentSize"

class XRBaseRefreshFooter: UIView {
    
    private var scroller: UIScrollView?
    
    public var refreshState: XRPullRefreshState = .idle {
        didSet {
            if refreshState != oldValue {
                if refreshState == .refreshing {
                    if self.refreshingClosure != nil {
                        self.refreshingClosure!()
                    }
                }
                
                DispatchQueue.main.async {
                    self.refreshStateChanged()
                }
            }
        }
    }
    
    public var progress: Double = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.pullProgressValueChanged()
            }
        }
    }
    
    var refreshingClosure: (() -> Swift.Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.prepareForRefresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let scroller = newSuperview as? UIScrollView {
            scroller.xr_contentInsetBottom += self.xr_height
            self.xr_y = scroller.xr_contentHeight
            self.scroller = scroller
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let scroller = self.superview as? UIScrollView {
            scroller.addObserver(self, forKeyPath: keyPathForContentOffset, options: NSKeyValueObservingOptions.new, context: nil)
            scroller.addObserver(self, forKeyPath: keyPathForContentSize, options: NSKeyValueObservingOptions.new, context: nil)
            
            self.scroller = scroller
            
            if (scroller.contentOffset.y + scroller.xr_height) > scroller.xr_contentHeight {
                if self.refreshState == .refreshing {
                    return
                }
                
                self.beginRefreshing()
            }
        }
    }
    
    override func removeFromSuperview() {
        
        if let scroller = self.superview as? UIScrollView {
            scroller.removeObserver(self, forKeyPath: keyPathForContentOffset, context: nil)
            scroller.removeObserver(self, forKeyPath: keyPathForContentSize, context: nil)
            scroller.xr_contentInsetBottom -= self.xr_height
            self.refreshState = .idle
        }
        super.removeFromSuperview()
    }
    
    /// 子类根据自己的需求实现以下方法
    // 初始化
    func prepareForRefresh() {
        
        self.refreshState = .idle
        self.backgroundColor = UIColor.clear
    }
    
    func refreshStateChanged() {
        
    }
    
    func pullProgressValueChanged() {
        
    }
    
    func beginRefreshing() {
        
        self.refreshState = .refreshing
    }
    
    func endRefreshing() {
        
        if self.refreshState == .refreshing {
            self.refreshState = .idle
        }
    }
    
    func endRefreshingWithNoMoreData() {
        
        if self.refreshState == .refreshing {
            self.refreshState = .noMoreData
        }
    }
    
    func endRefreshingWithLoadingFailure() {
        
        if self.refreshState == .refreshing {
            self.refreshState = .loadingFailure
        }
    }
    
    func removeLoadMoreRefreshing() {
        
        self.refreshState = .idle
        self.removeFromSuperview()
    }
    
    func scrollViewContentOffsetChanged(scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        let contentSize = scrollView.contentSize
        
        var fullDisplayOffsetY = contentSize.height + scrollView.xr_contentInsetBottom
        
        if XRRefreshControlSettings.sharedSetting.pullLoadingMoreMode == .ignorePullReleaseFast {
            fullDisplayOffsetY = contentSize.height + scrollView.xr_contentInsetBottom - self.xr_height
        }
        
        let halfDisplayOffsetY = contentSize.height + scrollView.xr_contentInsetBottom - self.xr_height * 0.5
        let changeOffsetY = contentOffset.y + scrollView.xr_height
        
        if contentOffset.y < scrollView.contentInset.top {
            return
        }
        
        if refreshState == .refreshing || refreshState == .noMoreData || refreshState == .loadingFailure {
            return
        }
        
        if XRRefreshControlSettings.sharedSetting.pullLoadingMoreMode == .ignorePullReleaseFast {
            
            if changeOffsetY > contentSize.height && changeOffsetY < halfDisplayOffsetY {
                self.refreshState = .pulling
            }
            else if changeOffsetY >= fullDisplayOffsetY {
                self.refreshState = .pullFulling
            }
            
            if self.refreshState == .pullFulling {
                self.beginRefreshing()
            }
            
            if contentOffset.y > contentSize.height {
                let distance = fabs(contentOffset.y)
                let absFullHeight = fabs(fullDisplayOffsetY)
                var progress = (distance - contentSize.height) / (absFullHeight - contentSize.height)
                progress = progress < 0 ? 0 : progress
                progress = progress > 1 ? 1 : progress
                self.progress = Double(progress)
            }
        }
        else if XRRefreshControlSettings.sharedSetting.pullLoadingMoreMode == .ignorePullRelease {
            if changeOffsetY > contentSize.height && changeOffsetY < halfDisplayOffsetY {
                self.refreshState = .pulling
            }
            else if changeOffsetY >= halfDisplayOffsetY && changeOffsetY < fullDisplayOffsetY {
                self.refreshState = .pullHalfing
            }
            else if changeOffsetY >= fullDisplayOffsetY {
                self.refreshState = .pullFulling
            }
            
            if self.refreshState == .pullFulling {
                self.beginRefreshing()
            }
            
            if contentOffset.y > contentSize.height {
                let distance = fabs(contentOffset.y)
                let absFullHeight = fabs(fullDisplayOffsetY)
                var progress = (distance - contentSize.height) / (absFullHeight - contentSize.height)
                progress = progress < 0 ? 0 : progress
                progress = progress > 1 ? 1 : progress
                self.progress = Double(progress)
            }
        }
        else {
            if scrollView.isDragging {
                if changeOffsetY > contentSize.height && changeOffsetY < halfDisplayOffsetY {
                    self.refreshState = .pulling
                }
                else if changeOffsetY >= halfDisplayOffsetY && changeOffsetY < fullDisplayOffsetY {
                    self.refreshState = .pullHalfing
                }
                else if changeOffsetY >= fullDisplayOffsetY {
                    self.refreshState = .pullFulling
                }
                
                if contentOffset.y > contentSize.height {
                    let distance = fabs(contentOffset.y)
                    let absFullHeight = fabs(fullDisplayOffsetY)
                    var progress = (distance - contentSize.height) / (absFullHeight - contentSize.height)
                    progress = progress < 0 ? 0 : progress
                    progress = progress > 1 ? 1 : progress
                    self.progress = Double(progress)
                }
            }
            else {
                if self.refreshState == .pullFulling {
                    self.beginRefreshing()
                }
            }
        }
    }
    
    // MARK: - Observe Lisener
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let keyPath_ = keyPath {
            if keyPath_ == keyPathForContentSize {
                if let changeDict = change {
                    if let contentSizeValue = changeDict[NSKeyValueChangeKey.newKey] as?  NSValue {
                        let contentSize = contentSizeValue.cgSizeValue
                        self.xr_y = contentSize.height
                    }
                }
            }
            else if keyPath_ == keyPathForContentOffset {
                if let _ = change , let scroller = object as? UIScrollView {
                    self.scrollViewContentOffsetChanged(scrollView: scroller)
                }
            }
        }
    }

}
