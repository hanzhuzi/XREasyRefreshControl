//
//  XRBaseRefreshHeader.swift
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

private let keyPathForContentOffset: String = "contentOffset"

@objc protocol XRBaseRefreshHeaderProtocol {
    @objc func refreshStateChanged()
    @objc optional func pullProgressValueChanged()
}

open class XRBaseRefreshHeader: UIView , XRBaseRefreshHeaderProtocol {
    
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
    
    // 忽略的refreshHeaderView顶部高度
    public var ignoreTopHeight: CGFloat = 0
    
    // 是否允许下拉距离超过下拉控件高度的一半就自动下拉至刷新状态<当刷新控件高度比较高时，请设置为`true`>
    private var isTriggerRefreshMoreThanPullHalfing: Bool = false
    // 触发下拉距离超过一半自动下拉至刷新状态的控件的最大高度值，默认200.
    // 可在`XRRefreshControlSettings`中配置.
    private var isTriggerRefreshPullHalfingHeaderMaxHeight: CGFloat {
        get {
            let maxHeight = XRRefreshControlSettings.sharedSetting.isTriggerRefreshPullHalfingHeaderMaxHeight
            return maxHeight
        }
    }
    
    var refreshingClosure: (() -> Swift.Void)?
    
    open override var frame: CGRect {
        get {
            return super.frame
        }
        
        set {
            super.frame = newValue
            if newValue.size.height >= isTriggerRefreshPullHalfingHeaderMaxHeight {
                isTriggerRefreshMoreThanPullHalfing = true
            }
            else {
                isTriggerRefreshMoreThanPullHalfing = false
            }
        }
    }
    
    // MARK: - init
    public init() {
        super.init(frame: CGRect.zero)
        
        self.prepareForRefresh()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let scroller = newSuperview as? UIScrollView {
            self.scroller = scroller
            contentInset_top = scroller.contentInset.top
            self.xr_y = -self.xr_height - contentInset_top
        }
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let scroller = self.superview as? UIScrollView {
            self.scroller = scroller
            contentInset_top = scroller.contentInset.top
            scroller.addObserver(self, forKeyPath: keyPathForContentOffset, options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    override open func removeFromSuperview() {
        
        if let scroller = self.superview as? UIScrollView {
            scroller.removeObserver(self, forKeyPath: keyPathForContentOffset)
        }
        super.removeFromSuperview()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bounds.size.height >= isTriggerRefreshPullHalfingHeaderMaxHeight {
            isTriggerRefreshMoreThanPullHalfing = true
        }
        else {
            isTriggerRefreshMoreThanPullHalfing = false
        }
    }
    
    // MARK: - Override Methods
    open func refreshStateChanged() {
        
    }
    
    open func pullProgressValueChanged() {
        
    }
    
    // MARK: - Initlzation
    open func prepareForRefresh() {
        
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
        let duration = XRRefreshControlSettings.sharedSetting.animateTimeForAdjustContentInSetTop
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                scroller_.xr_contentInsetTop = -fullDisplayOffsetY
                scroller_.xr_contentOffsetY = fullDisplayOffsetY
            }
        }
    }
    
    public func endRefreshing() {
        
        if self.refreshState == .refreshing {
            if let scroller_ = self.scroller {
                let delayTime = XRRefreshControlSettings.sharedSetting.afterDelayTimeForEndInsetTopRefreshing
                DispatchQueue.xr_dispatch_after_in_main(delayTime) {
                    self.refreshState = .finished
                    let duration = XRRefreshControlSettings.sharedSetting.animateTimeForEndRefreshContentInSetTop
                    UIView.animate(withDuration: duration,
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
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
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
                                    let distance = abs(contentOffset.y)
                                    let absFullHeight = abs(fullDisplayOffsetY)
                                    var progress = (distance - contentInset_top) / (absFullHeight - contentInset_top)
                                    progress = progress < 0 ? 0 : progress
                                    progress = progress > 1 ? 1 : progress
                                    self.progress = Double(progress)
                                }
                            }
                            else {
                                if isTriggerRefreshMoreThanPullHalfing {
                                    if self.refreshState == .pullHalfing || self.refreshState == .pullFulling {
                                        self.beginRefreshing()
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
    

}
