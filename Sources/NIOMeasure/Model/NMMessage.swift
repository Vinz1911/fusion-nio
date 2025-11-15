//
//  NMMessage.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 13.04.25.
//

import Foundation
import NIOCore

/// Protocol for message compliance
public protocol NMMessage: Sendable {
    var opcode: UInt8 { get }
    var raw: ByteBuffer { get }
}

/// Conformance to protocol 'NMMessage'
extension UInt16: NMMessage {
    public var opcode: UInt8 { NMOpcodes.ping.rawValue }
    public var raw: ByteBuffer { ByteBuffer(bytes: Array<UInt8>(repeating: .zero, count: Int(self))) }
}

/// Conformance to protocol 'NMMessage'
extension String: NMMessage {
    public var opcode: UInt8 { NMOpcodes.text.rawValue }
    public var raw: ByteBuffer { ByteBuffer(string: self) }
}

/// Conformance to protocol 'NMMessage'
extension ByteBuffer: NMMessage {
    public var opcode: UInt8 { NMOpcodes.binary.rawValue }
    public var raw: ByteBuffer { self }
}
