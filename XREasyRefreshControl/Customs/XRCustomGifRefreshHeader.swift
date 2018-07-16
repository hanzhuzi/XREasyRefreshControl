//
//  XRCustomGifRefreshHeader.swift
//  XREasyRefreshControl
//
//  Created by 徐冉 on 2018/7/12.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
import Gifu

class XRCustomGifRefreshHeader: XRBaseRefreshHeader {
    
    lazy var gifImageView: GIFImageView = GIFImageView(frame: CGRect.zero)
    
    override init() {
        super.init()
        
        self.addSubview(gifImageView)
        gifImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gifImageView.prepareForAnimation(withGIFNamed: "mugen")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gifImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gifImageView.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
    }
    
    // Overrides
    override func prepareForRefresh() {
        super.prepareForRefresh()
        
        
    }
    
    override func refreshStateChanged() {
        
        switch self.refreshState {
        case .idle:
            gifImageView.stopAnimatingGIF()
            break
        case .pulling:
            
            break
        case .pullHalfing:
            
            break
        case .pullFulling:
            
            break
        case .refreshing:
            gifImageView.startAnimatingGIF()
            break
        case .finished:
            gifImageView.stopAnimatingGIF()
            break
        default:
            break
        }
    }
    
    override func pullProgressValueChanged() {
        
        debugPrint("progress: \(self.progress)")
    }
    
}
