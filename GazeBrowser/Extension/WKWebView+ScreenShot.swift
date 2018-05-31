//
//  WKWebView+ScreenShot.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 30/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView{
    
    private func stageWebViewForScreenshot() {
        print("please not")
        let _scrollView = self.scrollView
        let pageSize = _scrollView.contentSize;
        let currentOffset = _scrollView.contentOffset
        let horizontalLimit = CGFloat(ceil(pageSize.width/_scrollView.frame.size.width))
        let verticalLimit = CGFloat(ceil(pageSize.height/_scrollView.frame.size.height))
        
        for i in stride(from: 0, to: verticalLimit, by: 1.0) {
            for j in stride(from: 0, to: horizontalLimit, by: 1.0) {
                _scrollView.scrollRectToVisible(CGRect(x: _scrollView.frame.size.width * j, y: _scrollView.frame.size.height * i, width: _scrollView.frame.size.width, height: _scrollView.frame.size.height), animated: true)
                RunLoop.main.run(until: Date.init(timeIntervalSinceNow: 1.0))
            }
        }
        _scrollView.setContentOffset(currentOffset, animated: false)
    }
    
    func fullLengthScreenshot(_ completionBlock: ((UIImage) -> Void)?) {
        
        // First stage the web view so that all resources are downloaded.
        
//        stageWebViewForScreenshot()
        let _scrollView = self.scrollView
        
        // Save the current bounds
        let tmp = self.bounds
        let tmpFrame = self.frame
        let currentOffset = _scrollView.contentOffset
        
        // Leave main thread alone for some time to let WKWebview render its contents / run its JS to load stuffs.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        
            // Re evaluate the size of the webview
            let pageSize = _scrollView.contentSize
            UIGraphicsBeginImageContext(pageSize)
            
            self.bounds = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: pageSize.width, height: pageSize.height)
            
            // Wait few seconds until the resources are loaded
            RunLoop.main.run(until: Date.init(timeIntervalSinceNow: 0.5))
            
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // reset Frame of view to origin
            self.bounds = tmp
            self.frame = tmpFrame
            _scrollView.setContentOffset(currentOffset, animated: false)
            
            completionBlock?(image)
        }
    }
}
