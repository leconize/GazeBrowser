//
//  MessageController.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 28/4/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import UIKit

class MessageController {
    
    var id: Int?
    var pageId: Int?
    
    let faceDetector: CIDetector
    
    init() {
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        self.faceDetector  = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
    }
    
    func createPageMessage(image: UIImage) -> SocketMessage? {
        guard let imageData = image.toJpg(quality: 0.3, width: Int(image.size.width), height: Int(image.size.height)) else { return nil }

        return SocketMessage(sessionId: 1, image: imageData)
    }
    
    func createMessage(image: UIImage, offset: CGPoint) -> SocketMessage? {
        // TODO Optimize CIImage 
        guard let pageId = self.pageId else { return nil }
        guard let imageData = image.toJpg(quality: 0.91, width: Int(image.size.width), height: Int(image.size.height)) else { return nil }
        
        guard let ciImage: CIImage = CIImage(data: imageData) else { return nil }
        
        let faceFeatures = self.faceDetector.features(in: ciImage)
        
        if faceFeatures.count == 0 {
            return nil
        }
        guard let tempFeature = faceFeatures[0] as? CIFaceFeature else { return nil }
        
        return SocketMessage(pageId: pageId, image: imageData, faceBound: tempFeature.bounds, leftEyePos: tempFeature.leftEyePosition, rightEyePos: tempFeature.rightEyePosition, parentViewOffset: offset)
    }
}



