import XCTest

@testable import SecretRabbitCode

final class SecretRabbitCodeTests: XCTestCase {
    func testSampleRateConversion() {
        let src = SecretRabbitCode()
        guard let src else {
            return XCTFail("Failed to initialize SecretRabbitCode")
        }
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        let output = src.convertSampleRate(input: input, fromRate: 44100, toRate: 48000)
        XCTAssertNotNil(output)
        XCTAssertEqual(output?.count, input.count * 48000 / 44100)
    }

    func testSampleRateConversionError() {
        let src = SecretRabbitCode()
        guard let src else {
            return XCTFail("Failed to initialize SecretRabbitCode")
        }
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        let output = src.convertSampleRate(input: input, fromRate: 44100, toRate: 0)
        XCTAssertNil(output)
    }

    func testPerformance() {
        let src = SecretRabbitCode()
        guard let src else {
            return XCTFail("Failed to initialize SecretRabbitCode")
        }
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        measure {
            for _ in 0..<1000 {
                let _ = src.convertSampleRate(input: input, fromRate: 44100, toRate: 48000)
            }
        }
    }
}
