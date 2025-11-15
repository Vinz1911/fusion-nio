//
//  NMFramer.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 13.04.25.
//

import Foundation
import NIOCore

internal actor NMFramer: Sendable {
    private var buffer: ByteBuffer = .init()
    
    /// Create instance of `FKFramer`
    ///
    /// The `NKFramer` represents the fusion framing protocol.
    /// This is a very fast and lightweight message framing protocol that supports `String` and `Data` based messages.
    /// It also supports `UInt16` for ping based transfer responses.
    /// The protocol's overhead per message is only `0x5` bytes, resulting in high performance.
    ///
    /// This protocol is based on a standardized Type-Length-Value Design Scheme.
    internal init() {
        self.buffer.clear()
    }
    
    /// Clear the message buffer
    ///
    /// Current message buffer will be cleared to
    /// prevent potential buffer overflow
    internal func reset() async -> Void {
        self.buffer.clear()
    }
    
    /// Create a protocol conform message frame
    ///
    /// - Parameter message: generic type which conforms to `Data` and `String`
    /// - Returns: generic Result type returning data and possible error
    internal static func create<T: NMMessage>(message: T) async throws -> ByteBuffer {
        let total = message.raw.readableBytes + NMConstants.control.rawValue
        guard total <= NMConstants.frame.rawValue else { throw NMError.writeBufferOverflow }
        
        var frame = ByteBuffer(); var raw = message.raw
        frame.writeInteger(message.opcode)
        frame.writeInteger(UInt32(total), endianness: .big, as: UInt32.self)
        frame.writeBuffer(&raw)
        return frame
    }
    
    /// Parse a protocol conform message frame
    ///
    /// - Parameters:
    ///   - data: the data which should be parsed
    ///   - completion: completion block returns generic Result type with parsed message and possible error
    internal func parse(data: inout ByteBuffer) async throws -> [NMMessage] {
        var messages: [NMMessage] = []; buffer.writeBuffer(&data); let index = NMConstants.control.rawValue
        guard var length = buffer.getInteger(at: 1, endianness: .big, as: UInt32.self) else { return .init() }
        guard buffer.readableBytes <= NMConstants.frame.rawValue else { throw NMError.readBufferOverflow }
        guard buffer.readableBytes >= NMConstants.control.rawValue, buffer.readableBytes >= length else { return .init() }
        while buffer.readableBytes >= length && length != .zero {
            guard let opcode = buffer.getInteger(at: buffer.readerIndex, as: UInt8.self) else { throw NMError.parsingFailed }
            
            switch opcode {
            case NMOpcodes.binary.rawValue: if let message = buffer.getBytes(at: index, length: Int(length) - index) { messages.append(ByteBuffer(bytes: message)) }
            case NMOpcodes.ping.rawValue: if let message = buffer.getBytes(at: index, length: Int(length) - index) { messages.append(UInt16(message.count)) }
            case NMOpcodes.text.rawValue: if let message = buffer.getString(at: index, length: Int(length) - index) { messages.append(message) }
            default: throw NMError.unexpectedOpcode }
            
            if buffer.readableBytes <= Int(length) { buffer.clear() } else { buffer.moveReaderIndex(forwardBy: Int(length)); buffer.discardReadBytes() }
            length = buffer.getInteger(at: buffer.readerIndex + 1, endianness: .big, as: UInt32.self) ?? .zero
        }
        return messages
    }
}
