//
//  Marcos.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/7/12.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import Foundation
import UIKit

//MARK: - 屏幕尺寸
// iPhone设备定义(物理尺寸)
func iSiPhoneX() -> Bool {
    return (UIScreen.main.bounds.size.width == 375 && UIScreen.main.bounds.size.height == 812) || (UIScreen.main.bounds.size.width == 812 && UIScreen.main.bounds.size.height == 375)
}

public let XR_NavigationBarHeight: CGFloat = iSiPhoneX() ? 88 : 64
