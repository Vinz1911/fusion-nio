//
//  FusionResultProtocol.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 13.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore

// MARK: - Fusion Result Protocol -

public protocol FusionResultProtocol: Sendable {
    /// The `FusionMessage`
    var message: FusionMessage { get }
    
    /// The current `NIOAsyncChannelOutboundWriter` from the connection
    var outbound: NIOAsyncChannelOutboundWriter<ByteBuffer> { get }
}

// MARK: - Fusion Endpoint Protocol -

public protocol FusionEndpointProtocol: Sendable {
    /// The host name
    var host: String { get }
    
    /// The port address
    var port: UInt16 { get }
}
