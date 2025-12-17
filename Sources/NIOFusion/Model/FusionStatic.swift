//
//  FusionStatic.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 17.04.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore

// MARK: - Ceiling -

/// The `FusionCeiling` to limit frame size
@frozen
public enum FusionCeiling: UInt32, Sendable {
    case low       = 0x800000
    case medium    = 0x1000000
    case high      = 0x2000000
    case extreme   = 0x4000000
    case unlimited = 0xFFFFFFFF
}

// MARK: - Message Flow Control -

/// The `FusionStatic` for protocol constants
enum FusionStatic: UInt32, Sendable {
    case opcode = 0x1
    case header = 0x5
    case total  = 0xFFFFFFFF
}

/// The `FusionOpcode` for the type classification
enum FusionOpcode: UInt8, Sendable {
    case string = 0x1
    case data   = 0x2
    case uint16 = 0x3
    
    /// The `FusionOpcode`rawType mapping
    var rawType: any FusionFrame.Type { switch self { case .string: String.self case .data: ByteBuffer.self case .uint16: UInt16.self } }
}
