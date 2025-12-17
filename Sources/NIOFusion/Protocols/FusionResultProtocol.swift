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
    
    /// Send data on the current channel
    ///
    /// - Parameters:
    ///   - message: the `FusionMessage` to send
    func send(_ message: FusionMessage) async throws -> Void
}

// MARK: - Fusion Endpoint Protocol -

public protocol FusionEndpointProtocol: Sendable {
    /// The host name
    var host: String { get }
    
    /// The port address
    var port: UInt16 { get }
}
