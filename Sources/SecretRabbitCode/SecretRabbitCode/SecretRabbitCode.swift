internal import CSamplerate

public class SecretRabbitCode {
    private var converter: OpaquePointer?
    private var error: Int32 = 0

    public init(
        converterType: ConverterType = .linear,
        channels: Int32 = 1
    ) throws {
        self.converter = src_new(converterType.rawValue, channels, &error)
        guard error == 0 else {
            throw SecretRabbitCodeError.InitalizationFailed(description: String(from: error))
        }
    }

    deinit {
        src_delete(converter)
    }
}

extension SecretRabbitCode {
    
    func process (
        inputData: [Float],
        outputData: inout [Float],
        ratio: Double
    ) throws -> Int {
        var totalInputFramesUsed: Int = 0
        var totalOutputFramesGenerated: Int = 0

        while totalInputFramesUsed < inputData.count {
            let remainingInputFrames = inputData.count - totalInputFramesUsed
            let remainingOutputFrames = outputData.count - totalOutputFramesGenerated

            guard remainingOutputFrames > 0 else {
                throw SecretRabbitCodeError.ConversionFailed(
                    description: "Output buffer is full before all input was consumed."
                )
            }

            var data = inputData.withUnsafeBufferPointer { inputBuffer in
                outputData.withUnsafeMutableBufferPointer { outputBuffer in
                    SRC_DATA(
                        data_in: inputBuffer.baseAddress!.advanced(by: totalInputFramesUsed),
                        data_out: outputBuffer.baseAddress!.advanced(by: totalOutputFramesGenerated),
                        input_frames: remainingInputFrames,
                        output_frames: remainingOutputFrames,
                        input_frames_used: 0,
                        output_frames_gen: 0,
                        end_of_input: 0,
                        src_ratio: ratio
                    )
                }
            }

            error = src_process(converter, &data)

            guard error == 0 else {
                throw SecretRabbitCodeError.ConversionFailed(description: String(from: error))
            }

            guard data.input_frames_used > 0 || data.output_frames_gen > 0 else {
                throw SecretRabbitCodeError.ConversionFailed(
                    description: "Sample rate converter made no progress."
                )
            }

            totalInputFramesUsed += Int(data.input_frames_used)
            totalOutputFramesGenerated += Int(data.output_frames_gen)
        }

        return totalOutputFramesGenerated
    }
}
