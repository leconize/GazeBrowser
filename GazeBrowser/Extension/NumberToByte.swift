//
//  NumberToByte.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 3/5/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation
import CoreGraphics

extension Int8 {
    
    mutating func toByte() -> Data {
        return Data(bytes: &self, count: MemoryLayout.size(ofValue: self))
    }
}

extension Int {
    
    mutating func toByte() -> Data {
        return Data(bytes: &self, count: MemoryLayout.size(ofValue: self))
    }
}

extension CGRect {
    
    func toByte() -> Data {
        var data = Data()
        data.append(origin.toByte())
        data.append(self.width.toByte())
        data.append(self.height.toByte())
        return data
    }
}

extension CGPoint {
    
    func toByte() -> Data {
        var data = Data()
        data.append(x.toByte())
        data.append(y.toByte())
        return data
    }
}

extension CGFloat {
    
    func toByte() -> Data {
        var float = Float(self)
        return Data(bytes: &float, count: MemoryLayout.size(ofValue: float))
    }
}
extension Float {
    mutating func toByte() -> Data {
        return Data(bytes: &self, count: MemoryLayout.size(ofValue: self))
    }
}
