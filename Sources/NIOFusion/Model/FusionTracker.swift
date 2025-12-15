//
//  NIOFusionTracker.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 12.11.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import Foundation
import NIOCore
import Logging

actor FusionTracker: FusionTrackerProtocol {
    private var addresses: [String: Date] = [:]
    private let expiration: TimeInterval
    
    /// Create instance of `FusionTracker`
    ///
    /// - Parameter expiration: reset interval
    init(expiration: TimeInterval = 30) {
        self.expiration = expiration
    }
    
    /// Track incoming IP Addresses
    ///
    /// - Parameter channel: from `any Channel`
    func fetch(from channel: any Channel) async -> Void {
        guard let address = channel.remoteAddress, let ip = address.ipAddress else { return }
        if await logable(from: ip) { Logger.shared.info("IP-Address: \(ip), Port: \(address.port ?? -1)") }
    }
}

// MARK: - Private API Extension -

private extension FusionTracker {
    /// Address to log
    ///
    /// - Parameter address: the ip address
    /// - Returns: true if it should log again
    private func logable(from address: String) async -> Bool {
        let now = Date(); addresses = addresses.filter { now.timeIntervalSince($0.value) < expiration }
        guard addresses[address] == nil else { return false }; addresses[address] = now; return true
    }
}
