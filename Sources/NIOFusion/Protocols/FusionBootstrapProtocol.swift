//
//  FusionBootstrapProtocol.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 15.11.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore
import NIOPosix

public protocol FusionBootstrapProtocol: Sendable {
    /// Create instance of `FusionBootstrap`
    ///
    /// - Parameters:
    ///   - endpoint: the `FusionEndpoint` to bind to
    ///   - threads: the thread count for the `MultiThreadedEventLoopGroup`
    ///   - parameters: the configurable `FusionParameters`
    init(from endpoint: FusionEndpoint, threads: Int, parameters: FusionParameters)

    /// Starts the `FusionBootstrap` and binds the server to port and address
    ///
    /// Invokes the individual channel listner
    func run() async throws -> Void

    /// Receive `FusionResult` from stream
    ///
    /// An continues `AsyncStream` returns `FusionResult`
    func receive() -> AsyncStream<FusionResult>
    
    /// Send data on specific channel
    ///
    /// - Parameters:
    ///   - message: the `FusionMessage` to send
    ///   - outbound: the outbound channel `NIOAsyncChannelOutboundWriter`
    func send(_ message: FusionMessage, _ outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>) async -> Void
    
    /// Show info
    ///
    /// Print logo and usefull information
    func info() -> Void
}
