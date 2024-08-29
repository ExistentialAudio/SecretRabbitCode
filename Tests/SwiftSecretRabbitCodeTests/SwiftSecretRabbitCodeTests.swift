import XCTest

@testable import SecretRabbitCode

final class SecretRabbitCodeTests: XCTestCase {
    func testSampleRateConversion() throws {
        let src = try SecretRabbitCode()
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        let output = try src.convertSampleRate(of: input, from: 44100, to: 48000)
        XCTAssertEqual(output.count, input.count * 48000 / 44100)
    }

    func testSampleRateConversionError() throws {
        let src = try SecretRabbitCode()
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        XCTAssertThrowsError(try src.convertSampleRate(of: input, from: 44100, to: 0))
    }

    func testPerformance() throws {
        let src = try SecretRabbitCode()
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        measure {
            for _ in 0 ..< 1000 {
                let _ = try! src.convertSampleRate(of: input, from: 44100, to: 48000)
            }
        }
    }
}
