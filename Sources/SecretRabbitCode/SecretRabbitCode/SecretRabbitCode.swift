internal import CSamplerate

public class SecretRabbitCode {
    private let converter: OpaquePointer
    private let channelCount: Int

    public init(
        converterType: ConverterType = .linear,
        channels: Int32 = 1
    ) throws(SecretRabbitCodeError) {
        var error: Int32 = 0

        guard let converter = src_new(converterType.rawValue, channels, &error) else {
            throw .initalizationFailed(description: String(from: error))
        }

        self.converter = converter
        self.channelCount = Int(channels)
    }

    deinit {
        src_delete(converter)
    }
}

extension SecretRabbitCode {
    
    public func process (
        inputData: [Float],
        inputFrameCount: Int,
        outputData: inout [Float],
        ratio: Double
    ) throws(SecretRabbitCodeError) -> Int {
        guard inputFrameCount >= 0,
              inputFrameCount <= inputData.count / channelCount else {
            throw .conversionFailed(description: "Invalid input frame count.")
        }

        let outputFrameCapacity = outputData.count / channelCount
        var totalInputFramesUsed = 0
        var totalOutputFramesGenerated = 0

        while totalInputFramesUsed < inputFrameCount {
            let remainingInputFrames = inputFrameCount - totalInputFramesUsed
            let remainingOutputFrames = outputFrameCapacity - totalOutputFramesGenerated

            guard remainingOutputFrames > 0 else {
                throw .conversionFailed(
                    description: "Output buffer is full before all input was consumed."
                )
            }

            let result = inputData.withUnsafeBufferPointer { inputBuffer in
                outputData.withUnsafeMutableBufferPointer { outputBuffer in
                    var data = SRC_DATA(
                        data_in: inputBuffer.baseAddress!.advanced(
                            by: totalInputFramesUsed * channelCount
                        ),
                        data_out: outputBuffer.baseAddress!.advanced(
                            by: totalOutputFramesGenerated * channelCount
                        ),
                        input_frames: remainingInputFrames,
                        output_frames: remainingOutputFrames,
                        input_frames_used: 0,
                        output_frames_gen: 0,
                        end_of_input: 0,
                        src_ratio: ratio
                    )

                    let status = src_process(converter, &data)
                    return (
                        status: status,
                        inputFramesUsed: data.input_frames_used,
                        outputFramesGenerated: data.output_frames_gen
                    )
                }
            }

            guard result.status == 0 else {
                throw .conversionFailed(description: String(from: result.status))
            }

            guard result.inputFramesUsed > 0 || result.outputFramesGenerated > 0 else {
                throw .conversionFailed(
                    description: "Sample rate converter made no progress."
                )
            }

            totalInputFramesUsed += result.inputFramesUsed
            totalOutputFramesGenerated += result.outputFramesGenerated
        }

        return totalOutputFramesGenerated
    }
}
