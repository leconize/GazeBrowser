//
//  Message.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 3/5/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import CoreImage


enum SocketType: Int8 {
    case startConnection = 0
    case sendWebpage = 1
    case sendFaceImage = 2
}

struct SocketMessage {
    
    var data: Data
    
    init(pageId: Int, image: Data, faceBound:CGRect, leftEyePos: CGPoint, rightEyePos: CGPoint, parentViewOffset: CGPoint)  {
        
        var data = Data()
        var id = pageId
        var type = SocketType.sendFaceImage.rawValue
        data.append(type.toByte())
        data.append(id.toByte())
        var imageSize: Int = image.count
        data.append(imageSize.toByte())
        data.append(image)
        data.append(faceBound.toByte())
        data.append(leftEyePos.toByte())
        data.append(rightEyePos.toByte())
        data.append(parentViewOffset.toByte())
        self.data = data
    }
    
    init(sessionId: Int, image: Data) {
        var data = Data()
        var type = SocketType.sendWebpage.rawValue
        data.append(type.toByte())
        var imageSize = image.count
        print(imageSize)
        data.append(imageSize.toByte())
        data.append(image)
        self.data = data
        print(data.count)
    }
    
    init(image: Data) {
        var data = Data()
        data.append(image)
        self.data = data
        print(data.count)
    }
}
