//
//  NFKOpcodes.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 17.04.25.
//

import Foundation

/// Opcodes for framing
internal enum NFKOpcodes: UInt8, Sendable {
    case none = 0x0
    case text = 0x1
    case binary = 0x2
    case ping = 0x3
}

/// Protocol byte constants
internal enum NFKConstants: Int, Sendable {
    case opcode = 0x1
    case control = 0x5
    case frame = 0xFFFFFFFF
}
