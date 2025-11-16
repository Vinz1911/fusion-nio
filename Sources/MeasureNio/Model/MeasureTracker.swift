//
//  MeasureTracker.swift
//  MeasureNio
//
//  Created by Vinzenz Weist on 12.11.25.
//

import Foundation

internal actor MeasureTracker: MeasureTrackerProtocol, Sendable {
    private var addresses: [String: Date] = [:]
    private let expiration: TimeInterval
    
    /// Create instance of `MeasureTracker`
    ///
    /// - Parameter expiration: reset interval
    internal init(expiration: TimeInterval = 30) {
        self.expiration = expiration
    }
    
    /// Address to log
    ///
    /// - Parameter address: the ip address
    /// - Returns: true if it should log again
    internal func log(_ address: String) async -> Bool {
        let now = Date(); addresses = addresses.filter { now.timeIntervalSince($0.value) < expiration }
        guard addresses[address] == nil else { return false }; addresses[address] = now; return true
    }
}
