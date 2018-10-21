//
//  XRRefreshMarcos.swift
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

final public class XRRefreshMarcos {
    
    public static let xr_StatusBarHeight: CGFloat = {
        if iSiPhoneXSerries() {
            return 44
        }
        return 20
    }()
    
    public static let xr_BottomIndicatorHeight: CGFloat = {
        if iSiPhoneXSerries() {
            return 34
        }
        return 0
    }()
    
    public static let xr_navigationBarHeight: CGFloat = {
        return 44
    }()
    
    //MARK: - 屏幕尺寸
    // iPhoneX, XS
    static func iSiPhoneX_XS() -> Bool {
        
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 1125, height: 2436)) : false) || (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 2436, height: 1125)) : false)
    }
    
    // iPhoneXR
    static func iSiPhoneXR() -> Bool {
        
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 828, height: 1792)) : false) || (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 1792, height: 828)) : false)
    }
    
    // iPhoneXS_Max
    static func iSiPhoneXS_Max() -> Bool {
        
        return (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 1242, height: 2688)) : false) || (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 2688, height: 1242)) : false)
    }
    
    // 是否有齐刘海和虚拟指示器
    static func iSiPhoneXSerries() -> Bool {
        
        var isiPhoneXSerries: Bool = false
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            isiPhoneXSerries = false
        }
        
        if #available(iOS 11.0, *) {
            if let mainWindow = UIApplication.shared.delegate?.window {
                if mainWindow!.safeAreaInsets.bottom > 0 {
                    isiPhoneXSerries = true
                }
            }
        }
        
        isiPhoneXSerries = iSiPhoneX_XS() || iSiPhoneXR() || iSiPhoneXS_Max()
        
        return isiPhoneXSerries
    }
    
}
