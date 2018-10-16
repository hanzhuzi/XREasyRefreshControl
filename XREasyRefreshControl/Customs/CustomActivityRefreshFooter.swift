//
//  XRActivityRefreshFooter.swift
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

public class CustomActivityRefreshFooter: XRBaseRefreshFooter {
    
    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    lazy var statusLbl: UILabel = UILabel(frame: CGRect.zero)
    
    override public init() {
        super.init()
        
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.refreshState == .noMoreData || self.refreshState == .loadingFailure {
            statusLbl.frame = CGRect(x: (self.bounds.size.width - statusLbl.bounds.size.width) * 0.5, y: (self.bounds.size.height - 35) * 0.5, width: statusLbl.bounds.size.width, height: 35)
        }
        else {
            statusLbl.frame = CGRect(x: (self.bounds.size.width - statusLbl.bounds.size.width) * 0.5 + 35 * 0.5, y: (self.bounds.size.height - 35) * 0.5, width: statusLbl.bounds.size.width, height: 35)
        }
        
        activityIndicator.frame = CGRect(x: statusLbl.frame.origin.x - 35, y: (self.bounds.size.height - 35) * 0.5, width: 35, height: 35)
    }
    
    override public func prepareForRefresh() {
        super.prepareForRefresh()
        
    }
    
    override public func refreshStateChanged() {
        
        switch refreshState {
        case .idle:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_idle)
            break
        case .pulling:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_idle)
            break
        case .pullHalfing:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_idle)
            break
        case .pullFulling:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_idle)
            break
        case .refreshing:
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_refreshing)
            break
        case .finished:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = false
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_finished)
            break
        case .noMoreData:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_noMoreData)
            break
        case .loadingFailure:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            statusLbl.text = XRLocalizableStringManager.localizableStringFromKey(key: XR_Refresh_footer_loadingFailure)
            break
        }
        
        statusLbl.sizeToFit()
        statusLbl.superview?.setNeedsLayout()
        statusLbl.superview?.layoutIfNeeded()
    }
    
    // pull progress changed
    override public func pullProgressValueChanged() {
        
    }
    
    // 加载失败了，重新加载
    @objc func reloadingWithLoadingFailureAction() {
        
        if self.refreshState == .loadingFailure {
            self.beginRefreshing()
        }
    }
    
}
