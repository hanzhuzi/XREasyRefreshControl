//
//  XRBaseRefreshHeader.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/6/20.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
/**
 - 下拉刷新基类
 */

import UIKit

private let keyPathForContentOffset: String = "contentOffset"

@objc protocol XRBaseRefreshHeaderProtocol {
    @objc func refreshStateChanged()
    @objc optional func pullProgressValueChanged()
}

public class XRBaseRefreshHeader: UIView , XRBaseRefreshHeaderProtocol {
    
    private var scroller: UIScrollView?
    private var contentInset_top: CGFloat = 0
    
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let scroller = newSuperview as? UIScrollView {
            self.scroller = scroller
            contentInset_top = scroller.contentInset.top
            self.xr_y = -self.xr_height - contentInset_top
        }
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let scroller = self.superview as? UIScrollView {
            self.scroller = scroller
            contentInset_top = scroller.contentInset.top
            scroller.addObserver(self, forKeyPath: keyPathForContentOffset, options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    override public func removeFromSuperview() {
        
        if let scroller = self.superview as? UIScrollView {
            scroller.removeObserver(self, forKeyPath: keyPathForContentOffset)
        }
        super.removeFromSuperview()
    }
    
    /// 子类根据自己的需求实现以下方法
    public func refreshStateChanged() {
        
    }
    
    public func pullProgressValueChanged() {
        
    }
    
    // 初始化
    public func prepareForRefresh() {
        
        self.refreshState = .idle
        self.backgroundColor = UIColor.clear
    }
    
    public func beginRefreshing() {
        
        guard let scroller_ = self.scroller else {
            return
        }
        
        self.refreshState = .refreshing
        self.progress = 1.0
        
        let fullDisplayOffsetY = -contentInset_top - self.frame.size.height
        
        UIView.animate(withDuration: XRRefreshControlSettings.sharedSetting.animateTimeForAdjustContentInSetTop, animations: {
            scroller_.xr_contentInsetTop = -fullDisplayOffsetY
        }) { (_) in
            // 不能在这里设置contentInset.top，会抖动.
        }
    }
    
    public func endRefreshing() {
        
        if self.refreshState == .refreshing {
            if let scroller_ = self.scroller {
                DispatchQueue.xr_dispatch_after_in_main(XRRefreshControlSettings.sharedSetting.afterDelayTimeForEndInsetTopRefreshing) {
                    self.refreshState = .finished
                    UIView.animate(withDuration: XRRefreshControlSettings.sharedSetting.animateTimeForEndRefreshContentInSetTop,
                                   animations: {
                        scroller_.xr_contentInsetTop = self.contentInset_top
                    }) { (_) in
                        self.refreshState = .idle
                        self.progress = 0.0
                    }
                }
            }
        }
    }
    
    // MARK: - Observe Lisener
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // contentOffset changed.
        if let keyPath_ = keyPath {
            if keyPath_ == keyPathForContentOffset {
                if let changeDict = change , let scroller = object as? UIScrollView {
                    if let contentOffsetValue = changeDict[NSKeyValueChangeKey.newKey] as? NSValue {
                        let contentOffset = contentOffsetValue.cgPointValue
                        
                        let fullDisplayOffsetY = -contentInset_top - self.frame.size.height
                        let halfDisplayOffsetY = -contentInset_top - self.frame.size.height * 0.5
                        
                        if refreshState == .refreshing || self.refreshState == .finished {
                            return
                        }
                        
                        if contentOffset.y >= contentInset_top {
                            return
                        }
                        else {
                            if scroller.isDragging {
                                if contentOffset.y < contentInset_top && contentOffset.y > halfDisplayOffsetY {
                                    self.refreshState = .pulling
                                }
                                else if contentOffset.y <= halfDisplayOffsetY && contentOffset.y > fullDisplayOffsetY {
                                    self.refreshState = .pullHalfing
                                }
                                else if contentOffset.y <= fullDisplayOffsetY {
                                    self.refreshState = .pullFulling
                                }
                                
                                if contentOffset.y < -contentInset_top {
                                    let distance = fabs(contentOffset.y)
                                    let absFullHeight = fabs(fullDisplayOffsetY)
                                    var progress = (distance - contentInset_top) / (absFullHeight - contentInset_top)
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
                }
            }
        }
    }
    

}
