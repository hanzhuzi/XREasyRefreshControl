//
//  XRActivityRefreshFooter.swift
//  XRRefresh
//
//  Created by 徐冉 on 2018/6/27.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class XRActivityRefreshFooter: XRBaseRefreshFooter {

    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    lazy var statusLbl: UILabel = UILabel(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        activityIndicator.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        self.addSubview(activityIndicator)
        
        activityIndicator.hidesWhenStopped = false
        activityIndicator.color = XRRefreshControlSettings.sharedSetting.refreshStatusLblTextColor
        
        statusLbl.textColor = XRRefreshControlSettings.sharedSetting.refreshStatusLblTextColor
        statusLbl.textAlignment = .center
        statusLbl.font = XRRefreshControlSettings.sharedSetting.refreshStatusLblTextFont
        statusLbl.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        statusLbl.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y)
        self.addSubview(statusLbl)
        statusLbl.isUserInteractionEnabled = true
        
        let statusLblTapGestrue = UITapGestureRecognizer(target: self, action: #selector(self.reloadingWithLoadingFailureAction))
        statusLblTapGestrue.numberOfTapsRequired = 1
        statusLbl.addGestureRecognizer(statusLblTapGestrue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.refreshState == .noMoreData || self.refreshState == .loadingFailure {
            statusLbl.frame = CGRect(x: (self.bounds.size.width - statusLbl.bounds.size.width) * 0.5, y: (self.bounds.size.height - 35) * 0.5, width: statusLbl.bounds.size.width, height: 35)
        }
        else {
            statusLbl.frame = CGRect(x: (self.bounds.size.width - statusLbl.bounds.size.width) * 0.5 + 35 * 0.5, y: (self.bounds.size.height - 35) * 0.5, width: statusLbl.bounds.size.width, height: 35)
        }
        
        activityIndicator.frame = CGRect(x: statusLbl.frame.origin.x - 35, y: (self.bounds.size.height - 35) * 0.5, width: 35, height: 35)
    }
    
    override func prepareForRefresh() {
        super.prepareForRefresh()
        
    }
    
    override func refreshStateChanged() {
        
        switch refreshState {
        case .idle:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = "上拉加载更多"
            break
        case .pulling:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = "上拉即可加载更多"
            break
        case .pullHalfing:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = "继续上拉加载更多"
            break
        case .pullFulling:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = "松手加载更多"
            break
        case .refreshing:
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = "加载中"
            break
        case .finished:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = "加载完成"
            break
        case .noMoreData:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            statusLbl.text = "没有更多数据了"
            break
        case .loadingFailure:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            statusLbl.text = "加载失败了，点击重新加载"
            break
        }
        
        statusLbl.sizeToFit()
        statusLbl.superview?.setNeedsLayout()
        statusLbl.superview?.layoutIfNeeded()
    }
    
    // pull progress changed
    override func pullProgressValueChanged() {
        
    }
    
    // 加载失败了，重新加载
    @objc func reloadingWithLoadingFailureAction() {
        
        if self.refreshState == .loadingFailure {
            self.beginRefreshing()
        }
    }
    
}
