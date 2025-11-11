//
//  NMError.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 17.04.25.
//

import Foundation

/// The `NMBootstrap` specific errors
@frozen
public enum NMError: Error, Sendable {
    case missingHost
    case missingPort
    case connectionTimeout
    case parsingFailed
    case readBufferOverflow
    case writeBufferOverflow
    case unexpectedOpcode
    
    public var description: String {
        switch self {
        case .missingHost: return "missing host"
        case .missingPort: return "missing port"
        case .connectionTimeout: return "connection timeout"
        case .parsingFailed: return "message parsing failed"
        case .readBufferOverflow: return "read buffer overflow"
        case .writeBufferOverflow: return "write buffer overflow"
        case .unexpectedOpcode: return "unexpected opcode" }
    }
}
