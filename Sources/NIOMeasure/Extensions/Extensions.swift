//
//  Extensions.swift
//  NIOMeasure
//
//  Created by Vinzenz Weist on 17.04.25.
//

import Foundation
import Logging

internal extension String {
    /// Version number
    static let version = "v1.0.1"
    
    /// Prompt logo
    static let logo = #"""
    
     _____   _______________     ______  ___                                      
     ___  | / /___  _/_  __ \    ___   |/  /__________ ___________  _____________ 
     __   |/ / __  / _  / / /    __  /|_/ /_  _ \  __ `/_  ___/  / / /_  ___/  _ \
     _  /|  / __/ /  / /_/ /     _  /  / / /  __/ /_/ /_(__  )/ /_/ /_  /   /  __/
     /_/ |_/  /___/  \____/      /_/  /_/  \___/\__,_/ /____/ \__,_/ /_/    \___/ 
    +-----------------------------------------------------------------------------+
    | High performance TCP measurement server based on custom Fusion Engine.      |
    | Support's inbound and outbound connection speed measurement + RTT.          |
    | More information at: https://weist.org                                      |
    +-----------------------------------------------------------------------------+
    """#
}

internal extension Logger {
    /// Singleton to access logger
    static let shared = Logger(label: .init())
}

internal extension Int {
    /// The minimum buffer size
    static var minimum: Self { 0x4000 }
    
    /// The maximum buffer size
    static var maximum: Self { 0x400000 }
}
