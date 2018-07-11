//
//  DispatchQueue+XRRefresh.swift
//  TeaExpoentNet
//
//  Created by 徐冉 on 2018/7/6.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    ///延迟 afTime, 回调 block(in main 在主线程)
    class func xr_dispatch_after_in_main(_ afTime: TimeInterval,block: @escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64(afTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC) // 1s * popTime
        
        if popTime > DispatchTime(uptimeNanoseconds: 0) {
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: block)
        }
    }
}

