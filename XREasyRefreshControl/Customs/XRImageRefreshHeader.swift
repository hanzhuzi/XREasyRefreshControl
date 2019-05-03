//
//  XRImageRefreshHeader.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2019/5/2.
//  Copyright © 2019年 是心作佛. All rights reserved.
//

import UIKit

func xr_hexRgbColor(hexValue: Int) -> UIColor {
    
    return UIColor(red: CGFloat(Double(((hexValue & 0xFF0000) >> 16)) / 255.0), green: CGFloat(Double((hexValue & 0x00FF00) >> 8) / 255.0), blue: CGFloat(Double((hexValue & 0xFF)) / 255.0), alpha: 1)
}

class XRImageRefreshHeader: XRBaseRefreshHeader {
    
    var stateImageView: UIImageView = UIImageView(frame: CGRect.zero)
    var stateLbl: UILabel = UILabel(frame: CGRect.zero)
    
    override func prepareForRefresh() {
        super.prepareForRefresh()
        
        self.addSubview(stateLbl)
        stateLbl.textColor = xr_hexRgbColor(hexValue: 0xa8a8a8)
        stateLbl.font = UIFont.systemFont(ofSize: 13)
        stateLbl.textAlignment = .center
        
        self.addSubview(stateImageView)
        stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        stateImageView.tintColor = xr_hexRgbColor(hexValue: 0xa8a8a8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stateLbl.sizeToFit()
        stateLbl.center = CGPoint(x: self.bounds.size.width * 0.5 + 7, y: self.bounds.size.height * 0.5)
        
        stateImageView.sizeToFit()
        stateImageView.center = CGPoint(x: stateLbl.frame.minX - 15, y: self.bounds.size.height * 0.5)
    }
    
    override func refreshStateChanged() {
        super.refreshStateChanged()
        
        switch refreshState {
        case .idle:
            self.stopLoadingAnimation()
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateLbl.text = "下拉刷新"
            self.makeStateImageViewDown()
            break
        case .pulling:
            self.stopLoadingAnimation()
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateLbl.text = "下拉以刷新"
            self.makeStateImageViewDown()
            break
        case .pullHalfing:
            self.stopLoadingAnimation()
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateLbl.text = "下拉以刷新"
            
            self.makeStateImageViewDown()
            break
        case .pullFulling:
            self.stopLoadingAnimation()
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.makeStateImageViewUp()
            
            stateLbl.text = "松手即可刷新"
            break
        case .refreshing:
            
            stateLbl.text = "正在刷新"
            stateImageView.image = UIImage(named: "loading")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateImageView.transform = CGAffineTransform.identity
            self.startLoadingAnimation()
            
            break
        case .finished:
            
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateImageView.transform = CGAffineTransform.identity
            self.stopLoadingAnimation()
            
            stateLbl.text = "已刷新"
            break
        default:
            break
        }
        
        stateImageView.sizeToFit()
        stateLbl.sizeToFit()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func pullProgressValueChanged() {
        super.pullProgressValueChanged()
        
    }
    
    func makeStateImageViewUp() {
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            if let weakSelf = self {
                weakSelf.stateImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 180.0) * 179.99)
            }
        }
    }
    
    func makeStateImageViewDown() {
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            if let weakSelf = self {
                weakSelf.stateImageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    func startLoadingAnimation() {
        
        self.stateImageView.layer.removeAnimation(forKey: "rotationAnimationForStateImage")
        
        let rotateAnima = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnima.fromValue = 0
        rotateAnima.toValue = Double.pi * 2
        
        rotateAnima.duration = 1
        rotateAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        rotateAnima.autoreverses = false
        rotateAnima.fillMode = .forwards
        rotateAnima.repeatCount = HUGE
        rotateAnima.isRemovedOnCompletion = false
        
        self.stateImageView.layer.add(rotateAnima, forKey: "rotationAnimationForStateImage")
    }
    
    func stopLoadingAnimation() {
        
        self.stateImageView.layer.removeAnimation(forKey: "rotationAnimationForStateImage")
    }

}
