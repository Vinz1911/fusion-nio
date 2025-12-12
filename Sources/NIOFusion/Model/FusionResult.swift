//
//  FusionResult.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 12.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore

// MARK: - Fusion Result -

struct FusionResult: Sendable {
    var message: FusionMessage
    var outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>
    
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
