//
//  NFKMessage.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 13.04.25.
//

import Foundation

/// Protocol for message compliance
public protocol NFKMessage: Sendable {
    var opcode: UInt8 { get }
    var raw: Data { get }
}

/// Conformance to protocol 'NFKMessage'
extension UInt16: NFKMessage {
    public var opcode: UInt8 { NFKOpcodes.ping.rawValue }
    public var raw: Data { Data(count: Int(self)) }
}

/// Conformance to protocol 'NFKMessage'
extension String: NFKMessage {
    public var opcode: UInt8 { NFKOpcodes.text.rawValue }
    public var raw: Data { Data(self.utf8) }
}

/// Conformance to protocol 'NFKMessage'
extension Data: NFKMessage {
    public var opcode: UInt8 { NFKOpcodes.binary.rawValue }
    public var raw: Data { self }
}
