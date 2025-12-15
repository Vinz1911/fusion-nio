//
//  FusionResult.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 12.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore

// MARK: - Fusion Result -

public struct FusionResult: FusionResultProtocol, Sendable {
    public let message: FusionMessage
    public let outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>
    
    /// The `FusionResult`
    ///
    /// - Parameters:
    ///   - message: the `FusionMessage`
    ///   - outbound: the `NIOAsyncChannelOutboundWriter`
    init(message: FusionMessage, outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>) {
        self.message = message
        self.outbound = outbound
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
