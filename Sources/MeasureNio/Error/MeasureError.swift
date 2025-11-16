//
//  MeasureError.swift
//  MeasureNio
//
//  Created by Vinzenz Weist on 17.04.25.
//

// MARK: - Framer Error -

/// The `FusionFramerError` specific errors
@frozen
public enum FusionFramerError: Error, Sendable {
    case parsingFailed
    case readBufferOverflow
    case writeBufferOverflow
    case unexpectedOpcode
    
    public var description: String {
        switch self {
        case .parsingFailed: return "message parsing failed"
        case .readBufferOverflow: return "read buffer overflow"
        case .writeBufferOverflow: return "write buffer overflow"
        case .unexpectedOpcode: return "unexpected opcode" }
    }
}
