//
//  MallocAdapter.swift
//  NIOFusion
//
//  Created by Vinzenz Weist on 10.12.25.
//  Copyright © 2025 Vinzenz Weist. All rights reserved.
//

import NIOCore
import Logging

#if os(Linux)
import Glibc

@_silgen_name("mallopt")
private func mallopt(_ param: Int32, _ value: Int32) -> Int32
#endif

struct _Malloc {
    // glibc malloc.h parameters
    private static let M_TRIM_THRESHOLD: Int32 = -1
    private static let M_MMAP_THRESHOLD: Int32 = -3
    private static let M_ARENA_MAX: Int32      = -8

    static func configure() {
        #if os(Linux)
        mallopt(M_ARENA_MAX, 2)
        mallopt(M_TRIM_THRESHOLD, 131_072)
        mallopt(M_MMAP_THRESHOLD, 131_072)
        Logger.shared.error("Malloc configurated")
        #else
        Logger.shared.warning("Malloc configuration is not supported")
        #endif
    }
}
