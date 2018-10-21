//
//  XRActivityRefreshHeader.swift
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

public class XRActivityRefreshHeader: XRBaseRefreshHeader {

    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
    lazy var statusLbl: UILabel = UILabel(frame: CGRect.zero)
    
    override public init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = CGPoint(x: self.frame.size.width * 0.5, y: ignoreTopHeight + (self.frame.size.height - ignoreTopHeight) * 0.5 - 12)
        
        statusLbl.frame = CGRect(x: 0, y: 0, width: 200, height: 16)
        statusLbl.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 25)
    }
    
    public override func prepareForRefresh() {
        super.prepareForRefresh()
        
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
    
    override public func refreshStateChanged() {
        
        switch refreshState {
        case .idle:
            activityIndicator.stopAnimating()
            statusLbl.text = "下拉以刷新"
            break
        case .pulling:
            activityIndicator.stopAnimating()
            statusLbl.text = "下拉以刷新"
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
