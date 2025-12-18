//
//  FusionFramer.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 13.04.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore

actor FusionFramer: FusionFramerProtocol {
    private var buffer: ByteBuffer = .init()
    
    /// Clear the message buffer
    ///
    /// Current message buffer will be cleared
    func clear() async -> Void { self.buffer.clear() }
    
    /// Create a `FusionMessage` conform frame
    ///
    /// - Parameters:
    ///   - message: generic type which conforms to `FusionMessage`
    ///   - ceiling: the inbound buffer size limit from `FusionCeiling`
    /// - Returns: the message frame as `ByteBuffer`
    static nonisolated func create<Message: FusionFrame>(message: Message, ceiling: FusionCeiling = .unlimited) throws(FusionFramerError) -> ByteBuffer {
        guard message.size <= FusionStatic.total.rawValue, message.size <= ceiling.rawValue else { throw .outbound }
        var frame = ByteBuffer(); frame.writeInteger(message.opcode); frame.writeInteger(UInt32(message.size), endianness: .big, as: UInt32.self); frame.writeImmutableBuffer(message.encode)
        return frame
    }
    
    /// Parse a `FusionMessage` conform frame
    ///
    /// - Parameters:
    ///   - slice: pointer to the `ByteBuffer` which holds the `FusionMessage`
    ///   - ceiling: the inbound buffer size limit from `FusionCeiling`
    /// - Returns: a collection of `FusionMessage`s
    func parse(slice: ByteBuffer, ceiling: FusionCeiling = .unlimited) async throws(FusionFramerError) -> [FusionFrame] {
        var messages: [FusionFrame] = []; buffer.writeImmutableBuffer(slice)
        guard buffer.readableBytes <= FusionStatic.total.rawValue, buffer.readableBytes <= ceiling.rawValue else { throw .inbound }
        guard buffer.readableBytes >= FusionStatic.header.rawValue else { return .init() }
        while let length = try buffer.length(), buffer.readableBytes >= length && length != .zero {
            guard let opcode = buffer.getInteger(at: buffer.readerIndex, as: UInt8.self) else { throw .opcode }
            guard let message = buffer.decode(with: opcode, from: length) else { throw .decode }
            buffer.moveReaderIndex(forwardBy: Int(length)); buffer.discardReadBytes(); messages.append(message)
        }
        return messages
    }
}
