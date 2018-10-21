//
//  XRBaseRefreshFooter.swift
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
import Foundation

private let keyPathForContentOffset: String = "contentOffset"
private let keyPathForContentSize: String = "contentSize"

open class XRBaseRefreshFooter: UIView {
    
    private var scroller: UIScrollView?
    
    // 底部忽略的高度
    public var ignoreBottomHeight: CGFloat = 0
    
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
            scroller.xr_contentInsetBottom += self.xr_height
            self.xr_y = scroller.xr_contentHeight
            self.scroller = scroller
        }
    }
    
    override open func didMoveToSuperview() {
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
    
    override open func removeFromSuperview() {
        
        if let scroller = self.superview as? UIScrollView {
            scroller.removeObserver(self, forKeyPath: keyPathForContentOffset, context: nil)
            scroller.removeObserver(self, forKeyPath: keyPathForContentSize, context: nil)
            scroller.xr_contentInsetBottom -= self.xr_height
            self.refreshState = .idle
        }
        super.removeFromSuperview()
    }
    
    // MARK: - Override Methods
    open func prepareForRefresh() {
        
        self.refreshState = .idle
        self.backgroundColor = UIColor.clear
    }
    
    open func refreshStateChanged() {
        
    }
    
    open func pullProgressValueChanged() {
        
    }
    
    public func beginRefreshing() {
        
        self.refreshState = .refreshing
    }
    
    public func endRefreshing() {
        
        if self.refreshState == .refreshing {
            self.refreshState = .idle
        }
    }
    
    public func endRefreshingWithNoMoreData() {
        
        if self.refreshState == .refreshing || self.refreshState == .idle {
            self.refreshState = .noMoreData
        }
    }
    
    public func endRefreshingWithLoadingFailure() {
        
        if self.refreshState == .refreshing || self.refreshState == .idle {
            self.refreshState = .loadingFailure
        }
    }
    
    public func removeLoadMoreRefreshing() {
        
        self.refreshState = .idle
        self.removeFromSuperview()
    }
    
    func scrollViewContentOffsetChanged(scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset
        let contentSize = scrollView.contentSize
        
        var fullDisplayOffsetY = contentSize.height + scrollView.xr_contentInsetBottom + ignoreBottomHeight
        
        if XRRefreshControlSettings.sharedSetting.pullLoadingMoreMode == .ignorePullReleaseFast {
            fullDisplayOffsetY = contentSize.height + scrollView.xr_contentInsetBottom - self.xr_height
        }
        
        let halfDisplayOffsetY = contentSize.height + scrollView.xr_contentInsetBottom + ignoreBottomHeight - self.xr_height * 0.5
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
                let distance = abs(contentOffset.y)
                let absFullHeight = abs(fullDisplayOffsetY)
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
                let distance = abs(contentOffset.y)
                let absFullHeight = abs(fullDisplayOffsetY)
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
                    let distance = abs(contentOffset.y)
                    let absFullHeight = abs(fullDisplayOffsetY)
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
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
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
