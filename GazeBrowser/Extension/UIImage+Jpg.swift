//
//  UIImage+Jpg.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 28/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func toJpg(quality: Float, width:Int, height: Int) -> Data? {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: self.size))
        
        guard let redraw = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        guard let imageData = UIImageJPEGRepresentation(redraw, CGFloat(quality)) else { return nil }
        
        return imageData
    }
}
