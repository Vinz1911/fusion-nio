//
//  FusionResult.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 12.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore
import Foundation
import Logging

// MARK: - Fusion Result -

public struct FusionResult: FusionResultProtocol, Sendable {
    public let id: UUID
    public let message: FusionMessage
    private let outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>
    private let ceiling: FusionCeiling
    
    /// The `FusionResult`
    ///
    /// - Parameters:
    ///   - message: the `FusionMessage`
    ///   - ceiling: the `FusionCeiling` to limit frame size
    ///   - outbound: the `NIOAsyncChannelOutboundWriter`
    init(id: UUID, message: FusionMessage, outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>, ceiling: FusionCeiling) {
        self.id = id
        self.message = message
        self.outbound = outbound
        self.ceiling = ceiling
    }
    
    /// Send data on the current channel
    ///
    /// - Parameters:
    ///   - message: the `FusionMessage` to send
    public func send(_ message: FusionMessage) async -> Void {
        guard let message = message as? FusionFrame else { return }
        do { let frame = try FusionFramer.create(message: message, ceiling: ceiling); try await outbound.write(frame) }
        catch { Logger.shared.error("\(error)") }
    }
}

// MARK: - Fusion Endpoint -

public struct FusionEndpoint: FusionEndpointProtocol, Sendable {
    public let host: String
    public let port: UInt16
    
    /// Create an Endpoint
    ///
    /// - Parameters:
    ///   - host: the host as `String`
    ///   - port: the port as `UInt16`
    public init(host: String, port: UInt16) {
        self.host = host
        self.port = port
    }
}
