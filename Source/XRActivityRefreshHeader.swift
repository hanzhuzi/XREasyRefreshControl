//
//  XRActivityRefreshHeader.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/6/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

public class XRActivityRefreshHeader: XRBaseRefreshHeader {

    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    lazy var statusLbl: UILabel = UILabel(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5 - 12)
        self.addSubview(activityIndicator)
        
        activityIndicator.hidesWhenStopped = false
        activityIndicator.color = XRRefreshControlSettings.sharedSetting.refreshStatusLblTextColor
        
        statusLbl.textColor = XRRefreshControlSettings.sharedSetting.refreshStatusLblTextColor
        statusLbl.textAlignment = .center
        statusLbl.font = XRRefreshControlSettings.sharedSetting.refreshStatusLblTextFont
        statusLbl.frame = CGRect(x: 0, y: 0, width: 200, height: 16)
        statusLbl.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 25)
        self.addSubview(statusLbl)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5 - 12)
        
        statusLbl.frame = CGRect(x: 0, y: 0, width: 200, height: 16)
        statusLbl.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 25)
    }
    
    override public func refreshStateChanged() {
        
        switch refreshState {
        case .idle:
            activityIndicator.stopAnimating()
            statusLbl.text = "下拉以刷新"
            break
        case .pulling:
            activityIndicator.stopAnimating()
            statusLbl.text = "下拉即可刷新"
            break
        case .pullHalfing:
            activityIndicator.stopAnimating()
            statusLbl.text = "继续下拉即可刷新"
            break
        case .pullFulling:
            activityIndicator.startAnimating()
            statusLbl.text = "松手即可刷新"
            break
        case .refreshing:
            activityIndicator.startAnimating()
            statusLbl.text = "刷新中"
            break
        case .finished:
            activityIndicator.stopAnimating()
            statusLbl.text = "刷新完成"
            break
        default:
            break
        }
    }
    
    // pull progress changed
    override public func pullProgressValueChanged() {
        
    }

}
