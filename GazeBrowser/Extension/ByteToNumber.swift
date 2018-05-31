//
//  ByteToNumber.swift
//  GazeBrowser
//
//  Created by Supphawit Getmark on 11/5/2561 BE.
//  Copyright © 2561 King Mongkut's Institute of Technology Ladkrabang. All rights reserved.
//

import Foundation

extension Data {
    var integer: Int {
        return withUnsafeBytes { $0.pointee }
    }
    var int32: Int32 {
        return withUnsafeBytes { $0.pointee }
    }
    var float: Float {
        return withUnsafeBytes { $0.pointee }
    }
    var float32: Float32 {
        return withUnsafeBytes { $0.pointee }
    }
    var double: Double {
        return withUnsafeBytes { $0.pointee }
    }
    var string: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}
