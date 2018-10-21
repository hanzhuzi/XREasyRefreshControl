//
//  XRRefreshControlSettings.swift
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

/**
 - XREasyRefreshControl 全局配置文件
 */

import Foundation
import UIKit

/// refreshHeader, refreshFooter刷新状态
public enum XRPullRefreshState {
    case idle           // 闲置时
    case pulling        // 下拉中(未超过可以刷新的下拉高度)
    case pullHalfing    // 下拉中（已超过可以刷新的下拉高度的一半）
    case pullFulling    // 下拉中(超过可以刷新的下拉高度)
    case refreshing     // 刷新中
    case finished       // 刷新完成
    case loadingFailure // 加载失败了
    case noMoreData     // 没有更多数据了
}

/** refreshFooter上拉加载触发方式
 - needPullRelease: 上拉时需要松手才进行刷新操作，且上拉距离需要完全超出contentSize.height+contentInset.bottom+footerView.height
- ignorePullRelease: 上拉时不需要松手即可进行刷新操作，且上拉距离需要完全超出contentSize.height+contentInset.bottom+footerView.height
- ignorePullReleaseFast: 上拉时只要refreshFooterView进入屏幕即进行刷新操作，上拉距离超出contentSize.height+contentInset.bottom，如微信朋友圈即是这种方式.
 */
public enum XRRefreshFooterPullLoadingMode {
    case needPullRelease       // 需要松手才进行刷新
    case ignorePullRelease     // 只要达到一定的上拉距离即进行刷新
    case ignorePullReleaseFast // 不需要用户松手，上拉距离忽略footer的高度
}

public class XRRefreshControlSettings: NSObject {
    
    public var screenSize: CGSize = UIScreen.main.bounds.size
    public var animateTimeForAdjustContentInSetTop: TimeInterval = 0.6
    public var animateTimeForEndRefreshContentInSetTop: TimeInterval = 0.5
    public var afterDelayTimeForEndInsetTopRefreshing: TimeInterval = 0.5
    
    public var pullLoadingMoreMode: XRRefreshFooterPullLoadingMode = .ignorePullReleaseFast
    public var refreshStatusLblTextColor: UIColor = XRRefreshControlSettings.colorFromRGB(hexRGB: 0x333333)
    public var refreshStatusLblTextFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    public var isTriggerRefreshPullHalfingHeaderMaxHeight: CGFloat = 200
    
    public static let sharedSetting: XRRefreshControlSettings = XRRefreshControlSettings()
    
    private override init() {
        super.init()
    }
    
    /**
     * @brief 全局配置刷新控件
     *
     * @param animateTimeForAdjustContentInSetTop     下拉后停留在刷新时的动画时间
     * @param animateTimeForEndRefreshContentInSetTop 结束刷新的动画时间
     * @param afterDelayTimeForEndInsetTopRefreshing  刷新完成后延时结束时间
     * @param pullLoadingMoreMode                     上拉加载触发模式
     * @param refreshStatusLblTextColor               刷新控件文字颜色
     * @param refreshStatusLblTextFont                刷新控件文字字体
     */
    public func configSettings(animateTimeForAdjustContentInSetTop: TimeInterval,
                        animateTimeForEndRefreshContentInSetTop: TimeInterval,
                        afterDelayTimeForEndInsetTopRefreshing: TimeInterval,
                        pullLoadingMoreMode: XRRefreshFooterPullLoadingMode = .ignorePullReleaseFast,
                        refreshStatusLblTextColor: UIColor? = nil,
                        refreshStatusLblTextFont: UIFont? = nil,
                        isTriggerRefreshPullHalfingHeaderMaxHeight: CGFloat = 200) {
        
        self.animateTimeForEndRefreshContentInSetTop = animateTimeForEndRefreshContentInSetTop
        self.animateTimeForEndRefreshContentInSetTop = animateTimeForEndRefreshContentInSetTop
        self.afterDelayTimeForEndInsetTopRefreshing = afterDelayTimeForEndInsetTopRefreshing
        self.pullLoadingMoreMode = pullLoadingMoreMode
        self.isTriggerRefreshPullHalfingHeaderMaxHeight = isTriggerRefreshPullHalfingHeaderMaxHeight
        
        if let statusLblTextColor = refreshStatusLblTextColor {
            self.refreshStatusLblTextColor = statusLblTextColor
        }
        
        if let statusLblTextFont = refreshStatusLblTextFont {
            self.refreshStatusLblTextFont = statusLblTextFont
        }
    }
    
    public class func colorFromRGB(hexRGB: UInt32) -> UIColor {
        let redComponent = (hexRGB & 0xFF0000) >> 16
        let greenComponent = (hexRGB & 0x00FF00) >> 8
        let blueComponent = hexRGB & 0x0000FF
        
        return UIColor (red: CGFloat(redComponent)/255.0, green: CGFloat(greenComponent)/255.0, blue: CGFloat(blueComponent)/255.0, alpha: 1)
    }
    
}
