//
//  NMBootstrap.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 13.04.25.
//

import NIOCore
import NIOPosix
import Foundation

internal struct NMBootstrap: Sendable {
    private let host: String
    private let port: Int
    private let group: MultiThreadedEventLoopGroup
    
    /// Create instance of `NMBootstrap`
    ///
    /// - Parameters:
    ///   - host: the host address as `String`
    ///   - port: the port number as `UInt16`
    ///   - group: the event group as `MultiThreadedEventLoopGroup`
    internal init(host: String, port: Int, group: MultiThreadedEventLoopGroup) {
        self.host = host
        self.port = port
        self.group = group
    }
    
    /// Starts the bootstrap and binds the server to port and address.
    ///
    /// - Parameter completion: contains callback with parsed data and outbound writer.
    internal func run(_ completion: @escaping @Sendable (NMMessage, NIOAsyncChannelOutboundWriter<ByteBuffer>) async -> Void) async throws {
        let bootstrap = try await ServerBootstrap(group: self.group)
            .serverChannelOption(.socketOption(.so_reuseaddr), value: 1)
            .bind(host: self.host, port: self.port) { channel in
                channel.eventLoop.makeCompletedFuture {
                    let timer = channel.eventLoop.scheduleTask(in: .seconds(60)) { channel.close(promise: nil) }
                    channel.closeFuture.whenComplete { _ in timer.cancel() }
                    return try NIOAsyncChannel(
                        wrappingChannelSynchronously: channel,
                        configuration: NIOAsyncChannel.Configuration(inboundType: ByteBuffer.self, outboundType: ByteBuffer.self)
                    )
                }
            }
        print(String.logo)
        print("[Info]: Started, listening on \(self.host):\(self.port)")
        try await withThrowingDiscardingTaskGroup { group in
            try await bootstrap.executeThenClose { inbound in
                for try await channel in inbound {
                    group.addTask {
                        await connection(channel: channel) { await completion($0, $1) }
                    }
                }
            }
        }
    }
    
    /// Send data on specific connection.
    ///
    /// - Parameters:
    ///   - message: the `NMMessage` to send
    ///   - outbound: the specific `NIOAsyncChannelOutboundWriter`
    internal func send(_ message: NMMessage, _ outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>) async {
        do {
            let frame = try await NMFramer.create(message: message)
            try await outbound.write(.init(bytes: frame))
        } catch {
            print("[Error]: \(error)")
        }
    }
}

// MARK: - Private API -

private extension NMBootstrap {
    /// Connection handler for each individual connection.
    ///
    /// - Parameters:
    ///   - channel: the `NIOAsyncChannel`
    ///   - completion: the parsed `NMMessage` and `NIOAsyncChannelOutboundWriter`
    private func connection(channel: NIOAsyncChannel<ByteBuffer, ByteBuffer>, completion: @escaping @Sendable (NMMessage, NIOAsyncChannelOutboundWriter<ByteBuffer>) async -> Void) async {
        do {
            let framer = NMFramer()
            if let address = channel.channel.remoteAddress {
                print("[Info]: IP: \(address.ipAddress ?? "0.0.0.0"), Port: \(address.port ?? -1)")
            }
            try await channel.executeThenClose { inbound, outbound in
                for try await buffer in inbound {
                    var data = buffer; guard let bytes = data.readDispatchData(length: data.readableBytes) else { return }
                    for message in try await framer.parse(data: bytes) { await completion(message, outbound) }
                }
            }
            channel.channel.flush()
            await framer.reset()
        } catch {
            if let error = error as? IOError, error.errnoCode != ECONNRESET {
                print("[Error]: \(error)")
            }
        }
    }
}
