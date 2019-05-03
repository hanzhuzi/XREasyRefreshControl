//
//  XRImageRefreshFooter.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2019/5/3.
//  Copyright © 2019年 是心作佛. All rights reserved.
//

import UIKit

class XRImageRefreshFooter: XRBaseRefreshFooter {

    var stateImageView: UIImageView = UIImageView(frame: CGRect.zero)
    var stateLbl: UILabel = UILabel(frame: CGRect.zero)
    
    override func prepareForRefresh() {
        super.prepareForRefresh()
        
        self.addSubview(stateLbl)
        stateLbl.textColor = xr_hexRgbColor(hexValue: 0xA8A8A8)
        stateLbl.font = UIFont.systemFont(ofSize: 13)
        stateLbl.textAlignment = .center
        
        stateLbl.isUserInteractionEnabled = true
        
        let statusLblTapGestrue = UITapGestureRecognizer(target: self, action: #selector(self.reloadingWithLoadingFailureAction))
        statusLblTapGestrue.numberOfTapsRequired = 1
        stateLbl.addGestureRecognizer(statusLblTapGestrue)
        
        self.addSubview(stateImageView)
        stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        stateImageView.tintColor = xr_hexRgbColor(hexValue: 0xA8A8A8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stateLbl.sizeToFit()
        if self.refreshState == .noMoreData || self.refreshState == .loadingFailure {
            stateLbl.frame.size = CGSize(width: stateLbl.frame.size.width, height: 35)
            stateLbl.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        }
        else {
            stateLbl.center = CGPoint(x: self.bounds.size.width * 0.5 + 7, y: self.bounds.size.height * 0.5)
        }
        
        stateImageView.sizeToFit()
        stateImageView.center = CGPoint(x: stateLbl.frame.minX - 15, y: self.bounds.size.height * 0.5)
    }
    
    override func refreshStateChanged() {
        super.refreshStateChanged()
        
        switch refreshState {
        case .idle:
            self.stopLoadingAnimation()
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateLbl.text = "上拉加载"
            self.makeStateImageViewDown()
            break
        case .pulling:
            self.stopLoadingAnimation()
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateLbl.text = "上拉以加载"
            self.makeStateImageViewDown()
            break
        case .pullHalfing:
            self.stopLoadingAnimation()
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateLbl.text = "上拉以加载"
            
            self.makeStateImageViewDown()
            break
        case .pullFulling:
            self.stopLoadingAnimation()
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.makeStateImageViewUp()
            
            stateLbl.text = "松手加载更多"
            break
        case .refreshing:
            
            stateLbl.text = "正在加载"
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: "loading")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateImageView.transform = CGAffineTransform.identity
            self.startLoadingAnimation()
            
            break
        case .finished:
            
            stateImageView.isHidden = false
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateImageView.transform = CGAffineTransform.identity
            self.stopLoadingAnimation()
            
            stateLbl.text = "已加载"
            break
        case .noMoreData:
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateImageView.transform = CGAffineTransform.identity
            self.stopLoadingAnimation()
            stateImageView.isHidden = true
            
            stateLbl.text = "没有更多了~"
            break
        case .loadingFailure:
            stateImageView.image = UIImage(named: "icon_pull")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            stateImageView.transform = CGAffineTransform.identity
            self.stopLoadingAnimation()
            stateImageView.isHidden = true
            
            stateLbl.text = "加载失败，点击重新加载"
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
    
    // 加载失败了，重新加载
    @objc func reloadingWithLoadingFailureAction() {
        
        if self.refreshState == .loadingFailure {
            self.beginRefreshing()
        }
    }

}
