//
//  UIView+XRExtension.swift
//  TeaExpoentNet
//
//  Created by 徐冉 on 2018/7/6.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var xr_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            var tFrame = self.frame
            tFrame.origin.y = newValue
            self.frame = tFrame
        }
    }
    
    var xr_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            var tFrame = self.frame
            tFrame.origin.x = newValue
            self.frame = tFrame
        }
    }
    
    var xr_height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var tFrame = self.frame
            tFrame.size.height = newValue
            self.frame = tFrame
        }
    }
    
    var xr_width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var tFrame = self.frame
            tFrame.size.width = newValue
            self.frame = tFrame
        }
    }
    
}

