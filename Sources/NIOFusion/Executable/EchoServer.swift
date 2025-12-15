//
//  EchoServer.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 10.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore
import NIOPosix
import Logging

// @main << TODO: Enable -
struct EchoServer: Sendable {
    static let bootstrap = FusionBootstrap(from: .localhost)
    
    /// The `main` entry point.
    ///
    /// Start the `EchoServer` and receive data.
    static func main() async throws {
        bootstrap.info()
        Task { for await result in bootstrap.receive() { await bootstrap.send(result.message, result.outbound) } }
        try await bootstrap.run()
    }
}
