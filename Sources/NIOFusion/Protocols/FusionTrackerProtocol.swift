//
//  FusionTrackerProtocol.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 15.11.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import Foundation
import NIOCore

// MARK: - Fusion Tracker -

protocol FusionTrackerProtocol: Sendable {
    /// Create instance of `FusionTracker`
    ///
    /// - Parameter expiration: reset interval
    init(expiration: TimeInterval)
    
    /// Track incoming IP Addresses
    ///
    /// - Parameter channel: from `any Channel`
    func fetch(from channel: any Channel) async -> Void
}
