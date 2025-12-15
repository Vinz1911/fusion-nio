//
//  FusionParameters.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 15.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

public struct FusionParameters: FusionParametersProtocol, Sendable {
    public let timeout: UInt16?
    public let backlog: UInt16
    public let nodelay: Bool
    public let messages: UInt16
    public let logging: Bool
    
    /// Configurable `FusionParameters` for `FusionBootstrap`
    ///
    /// - Parameters:
    ///   - timeout: timeout after a connection will be kicked
    ///   - backlog: maximum allowed connections
    ///   - nodelay: enable tcp nagle's algorithmus
    ///   - messages: maximum messages per read
    ///   - logging: enable logging
    public init(timeout: UInt16? = nil, backlog: UInt16 = 256, nodelay: Bool = true, messages: UInt16 = 32, logging: Bool = true) {
        self.timeout = timeout
        self.backlog = backlog
        self.nodelay = nodelay
        self.messages = messages
        self.logging = logging
    }
}
