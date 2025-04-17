//
//  Extensions.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 17.04.25.
//

import Foundation

internal extension UInt32 {
    /// Convert integer to data with bigEndian
    var bigEndianData: Data { withUnsafeBytes(of: self.bigEndian) { Data($0) } }
}

internal extension Data {
    /// Extract integers from data as big endian
    var bigEndianUInt32: UInt32 {
        guard !self.isEmpty else { return .zero }
        return UInt32(bigEndian: withUnsafeBytes { $0.load(as: UInt32.self) })
    }
}
