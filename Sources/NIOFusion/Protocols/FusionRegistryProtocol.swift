//
//  FusionRegistryProtocol.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 18.12.25.
//

import Foundation
import NIOCore

protocol FusionRegistryProtocol: Sendable {
    /// Append a `NIOAsyncChannelOutboundWriter`
    ///
    /// - Parameters:
    ///   - id: the channel `UUID`
    ///   - outbound: the channel `NIOAsyncChannelOutboundWriter`
    func append(id: UUID, outbound: NIOAsyncChannelOutboundWriter<ByteBuffer>) async -> Void
    
    /// Fetch all `UUID`s from the registry
    ///
    /// - Returns: an array of all current channel `UUID`s
    func fetch() async -> [UUID]
    
    /// Fetch a `NIOAsyncChannelOutboundWriter`
    ///
    /// - Parameter id: the channel `UUID`
    /// - Returns: the channel `NIOAsyncChannelOutboundWriter`
    func fetch(from id: UUID) async -> NIOAsyncChannelOutboundWriter<ByteBuffer>?
    
    /// Remove a `NIOAsyncChannelOutboundWriter`
    ///
    /// - Parameter id: the channel `UUID`
    func remove(id: UUID) async -> Void
}
