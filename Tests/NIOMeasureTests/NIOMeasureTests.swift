import Testing
import NIOCore
@testable import NIOMeasure

@Test func parser() async throws {
    let framer = NMFramer()
    var buffer = ByteBuffer()
    
    var messageString = try await NMFramer.create(message: "Hello World! ⭐️")
    var messageBuffer = try await NMFramer.create(message: ByteBuffer(bytes: [0x0, 0x1, 0x2, 0x3, 0x4]))
    var messagePing = try await NMFramer.create(message: UInt16.max)
    
    buffer.writeBuffer(&messageString)
    buffer.writeBuffer(&messageBuffer)
    buffer.writeBuffer(&messagePing)
    
    let messages = try await framer.parse(data: &buffer)
    
    for message in messages {
        if let message = message as? String { print(message) }
        if let message = message as? ByteBuffer { print(message.readableBytes) }
        if let message = message as? UInt16 { print(message) }
    }
}
