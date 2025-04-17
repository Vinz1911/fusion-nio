//
//  NMServer.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 17.04.25.
//

import NIOCore
import NIOPosix
import Foundation

@main
internal struct NFKServer: Sendable {
    /// The `main` entry point.
    ///
    /// Start the `NFKServer` and receive data.
    /// This is used as Bandwidth measurement server, it receives data or a requested amount of data
    /// and sends the appropriated value back to the client.
    static func main() async throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let server = NFKBootstrap(host: "127.0.0.1", port: 7878, group: group)
        
        print("[NIOFusion]: Server starting...")
        try await server.run() { message, outbound in
            if let message = message as? String {
                await server.send(Data(count: Int(message)!), outbound)
            }
            if let message = message as? Data {
                await server.send("\(message.count)", outbound)
            }
        }
    }
}
