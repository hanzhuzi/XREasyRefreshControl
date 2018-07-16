//  UIView+XRExtension.swift
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

