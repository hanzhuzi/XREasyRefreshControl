//
//  XRRefreshControlSettings.swift
//  TeaExpoentNet
//
//  Created by 徐冉 on 2018/7/10.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
/**
 - XREasyRefreshControl 全局配置文件
 */

import Foundation
import UIKit

// 刷新状态
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

// 上拉加载模式
// @上拉时需要松手才进行刷新操作，且上拉距离需要完全超出contentSize.height+contentInset.bottom+footerView.height
// @上拉时不需要松手即可进行刷新操作，且上拉距离需要完全超出contentSize.height+contentInset.bottom+footerView.height
// @上拉时只要footerView一出现即可进行刷新操作，上拉距离超出contentSize.height+contentInset.bottom
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
    
    public var animateCircleLayerGradientColors: [UIColor] = [XRRefreshControlSettings.colorFromRGB(hexRGB: 0xCCCCCC), XRRefreshControlSettings.colorFromRGB(hexRGB: 0x111111)]
    public var animateCircleLayerGradientLocations: [NSNumber] = [0, 1.0]
    
    public var pullLoadingMoreMode: XRRefreshFooterPullLoadingMode = .ignorePullReleaseFast
    public var refreshStatusLblTextColor: UIColor = XRRefreshControlSettings.colorFromRGB(hexRGB: 0x333333)
    public var refreshStatusLblTextFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    public static let sharedSetting: XRRefreshControlSettings = XRRefreshControlSettings()
    
    private override init() {
        super.init()
    }
    
    /**
     @brief 全局配置刷新控件
     
     - animateTimeForAdjustContentInSetTop     下拉后停留在刷新时的动画时间
     - animateTimeForEndRefreshContentInSetTop 结束刷新的动画时间
     - afterDelayTimeForEndInsetTopRefreshing  刷新完成后延时结束时间
     - pullLoadingMoreMode 上拉加载触发模式
     - animateCircleLayerGradientColors     下拉刷新控件渐变颜色值数组
     - animateCircleLayerGradientLocations  下拉刷新控件渐变位置数组
     - refreshStatusLblTextColor 刷新控件文字颜色
     - refreshStatusLblTextFont  刷新控件文字字体
     */
    public func configSettings(animateTimeForAdjustContentInSetTop: TimeInterval,
                        animateTimeForEndRefreshContentInSetTop: TimeInterval,
                        afterDelayTimeForEndInsetTopRefreshing: TimeInterval,
                        pullLoadingMoreMode: XRRefreshFooterPullLoadingMode = .ignorePullReleaseFast,
                        animateCircleLayerGradientColors: [UIColor]? = nil,
                        animateCircleLayerGradientLocations: [NSNumber]? = nil,
                        refreshStatusLblTextColor: UIColor? = nil,
                        refreshStatusLblTextFont: UIFont? = nil) {
        
        self.animateTimeForEndRefreshContentInSetTop = animateTimeForEndRefreshContentInSetTop
        self.animateTimeForEndRefreshContentInSetTop = animateTimeForEndRefreshContentInSetTop
        self.afterDelayTimeForEndInsetTopRefreshing = afterDelayTimeForEndInsetTopRefreshing
        self.pullLoadingMoreMode = pullLoadingMoreMode
        if let gradientColors = animateCircleLayerGradientColors {
            self.animateCircleLayerGradientColors = gradientColors
        }
        
        if let gradientLocations = animateCircleLayerGradientLocations {
            self.animateCircleLayerGradientLocations = gradientLocations
        }
        
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
