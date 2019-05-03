//
//  XRCircleAnimatorRefreshHeader.swift
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

private let kRotationAnimationForGradientLayerKey: String = "kRotationAnimationForGradientLayerKey"
private let kStrokeEndAnimationForCircleLayerKey: String = "kStrokeEndAnimationForCircleLayerKey"

public class XRCircleAnimatorRefreshHeader: XRBaseRefreshHeader {
    
    lazy var backLayer: CAShapeLayer = CAShapeLayer()
    lazy var circleLayer: CAShapeLayer = CAShapeLayer()
    lazy var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func prepareForRefresh() {
        super.prepareForRefresh()
        
        backLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(backLayer)
        
        circleLayer.backgroundColor = UIColor.clear.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.lineJoin = CAShapeLayerLineJoin.round
        circleLayer.lineWidth = 3
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
        
        let gradientColors = [UIColor.init(red: CGFloat(160 / 255.0), green: CGFloat(160 / 255.0), blue: CGFloat(160 / 255.0), alpha: 1),
                              UIColor.init(red: CGFloat(50 / 255.0), green: CGFloat(50 / 255.0), blue: CGFloat(50 / 255.0), alpha: 1),
                              UIColor.init(red: CGFloat(160 / 255.0), green: CGFloat(160 / 255.0), blue: CGFloat(160 / 255.0), alpha: 1)
                              
                              ]
        var gradientCGColors: [CGColor] = []
        for gradientColor in gradientColors {
            gradientCGColors.append(gradientColor.cgColor)
        }
        
        gradientLayer.colors = gradientCGColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0, 1]
        self.backLayer.addSublayer(gradientLayer)
        
        backLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    override public func refreshStateChanged() {
        
        switch refreshState {
        case .idle:
            self.stopAnimation()
            break
        case .pulling:
            
            break
        case .pullHalfing:

            break
        case .pullFulling:
            
            break
        case .refreshing:
            self.startAnimation()
            break
        case .finished:
            self.stopAnimation()
            self.endCircleAnimation()
            break
        default:
            break
        }
    }
    
    override public func pullProgressValueChanged() {
        
        circleLayer.strokeEnd = CGFloat(progress)
    }
    
    override public var frame: CGRect {
        get {
            return super.frame
        }
        
        set {
            super.frame = newValue
            self.layoutCircleLayer()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutCircleLayer()
    }
    
    func layoutCircleLayer() {
        
        backLayer.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        backLayer.position = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        circleLayer.position = CGPoint(x: circleLayer.bounds.size.width * 0.5, y: circleLayer.bounds.size.height * 0.5)
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: circleLayer.bounds.size.width * 0.5, y: circleLayer.bounds.size.height * 0.5), radius: 12, startAngle: CGFloat(Double.pi / 180.0) * 45.0, endAngle: CGFloat(Double.pi / 180.0) * 345.0, clockwise: true)
        circleLayer.path = bezierPath.cgPath
        
        gradientLayer.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        gradientLayer.position = CGPoint(x: 15, y: 15)
        gradientLayer.mask = circleLayer
    }
    
    // animate for circle layer
    func startAnimation() {
        
        let rotateAnima = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnima.fromValue = 0
        rotateAnima.toValue = CGFloat(Double.pi * 2)
        rotateAnima.duration = 1
        rotateAnima.isRemovedOnCompletion = false
        rotateAnima.repeatCount = HUGE
        rotateAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.backLayer.add(rotateAnima, forKey: kRotationAnimationForGradientLayerKey)
    }
    
    func stopAnimation() {
        
        self.backLayer.removeAnimation(forKey: kRotationAnimationForGradientLayerKey)
    }
    
    func endCircleAnimation() {
        
        let strokeEndAnima = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnima.toValue = 0
        strokeEndAnima.duration = XRRefreshControlSettings.sharedSetting.animateTimeForEndRefreshContentInSetTop + XRRefreshControlSettings.sharedSetting.afterDelayTimeForEndInsetTopRefreshing
        strokeEndAnima.isRemovedOnCompletion = false
        strokeEndAnima.repeatCount = 1
        strokeEndAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        circleLayer.add(strokeEndAnima, forKey: kStrokeEndAnimationForCircleLayerKey)
    }
    
}
