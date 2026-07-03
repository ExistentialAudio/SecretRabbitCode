import Testing

@testable import SecretRabbitCode

struct SecretRabbitCodeTests {
    @Test func testSampleRateConversion() async throws {
        let inputSampleRate = 44100.0
        let outputSampleRate = 48000.0
        let src = try SecretRabbitCode()
        let input: [Float] = [Float](repeating: 1.0, count: Int(inputSampleRate))
        
        // We need extra space in the output buffer
        var output: [Float] = [Float](repeating: 1.0, count: Int(outputSampleRate) * 2)
        let outputFrameCount = try src.process(inputData: input, inputFrameCount: input.count, outputData: &output, ratio: outputSampleRate/inputSampleRate)
        
        // The generated frames will be either 48000 +- 1
        #expect((47999...48001).contains(outputFrameCount))
    }
    
    @Test func testSampleRateConversionError() async throws {
        let src = try SecretRabbitCode()
        let input: [Float] = [0.0, 1.0, 0.0, -1.0, 0.0]
        var output = [Float]()
        #expect(throws: SecretRabbitCodeError.ConversionFailed(description: "Output buffer is full before all input was consumed.")) {
            try src.process(inputData: input, inputFrameCount: input.count,outputData: &output, ratio: 0)
        }
    }
    
    @Test func testPerformance() async throws {
        let src = try SecretRabbitCode(converterType: .bestQuality)
        let inputSampleRate = 44100.0
        let outputSampleRate = 48000.0
        let input: [Float] = [Float](repeating: 1.0, count: Int(inputSampleRate))
        var output: [Float] = [Float](repeating: 1.0, count: Int(outputSampleRate) * 2)
        for _ in 0 ..< 100 {
            let outputFrameCount = try! src.process(inputData: input, inputFrameCount: input.count,outputData: &output, ratio: outputSampleRate/inputSampleRate)
        }
    }
}

