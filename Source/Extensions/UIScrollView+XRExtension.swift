//
//  UIScrollView+XRExtension.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/10/17.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension for contentInset
extension UIScrollView {
    
    var xr_contentInset: UIEdgeInsets {
        get {
            return self.contentInset
        }
        
        set {
            self.contentInset = newValue
        }
    }
    
    var xr_contentInsetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom = inset.bottom - (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
    }
    
    var xr_contentInsetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top = inset.top - (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }
    
    var xr_contentHeight: CGFloat {
        get {
            return self.contentSize.height
        }
        
        set {
            var contentSize = self.contentSize
            contentSize.height = newValue
            self.contentSize = contentSize
        }
    }
    
    var xr_contentOffsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        
        set {
            var contentOffSet_ = self.contentOffset
            contentOffSet_.y = newValue
            self.contentOffset = contentOffSet_
        }
    }
    
}
