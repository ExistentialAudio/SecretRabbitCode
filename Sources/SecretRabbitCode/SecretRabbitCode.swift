internal import CSamplerate


enum SecretRabbitCodeError: Error {
    case InitalizationFailed(description: String)
    case ConversionFailed(description: String)
}


extension String {
    init(from errorCode: Int32) {
        self = String(cString: src_strerror(errorCode))
    }
}


public class SecretRabbitCode {
    private var converter: OpaquePointer?
    private var error: Int32 = 0

    public init(
        converterType: Int32? = nil,
        channels: Int32 = 1
    ) throws {
        self.converter = src_new(converterType ?? Int32(SRC_LINEAR), channels, &error)
        guard error == 0 else {
            throw SecretRabbitCodeError.InitalizationFailed(description: String(from: error))
        }
    }

    deinit {
        src_delete(converter)
    }

    public func convertSampleRate(
        of input: [Float],
        from inputRate: Int,
        to outputRate: Int
    ) throws -> [Float] {
        var data_out = [Float](repeating: 0, count: input.count * outputRate / inputRate)
        var data_in = input.withUnsafeBufferPointer { buffer_in in
            return data_out.withUnsafeMutableBufferPointer { buffer_out in
                return SRC_DATA(
                    data_in: buffer_in.baseAddress,
                    data_out: buffer_out.baseAddress,
                    input_frames: input.count,
                    output_frames: input.count * outputRate / inputRate,
                    input_frames_used: 0,
                    output_frames_gen: 0,
                    end_of_input: 0,
                    src_ratio: Double(outputRate) / Double(inputRate)
                )
            }
        }

        error = src_process(converter, &data_in)

        guard error == 0 else {
            throw SecretRabbitCodeError.ConversionFailed(description: String(from: error))
        }

        return data_out
    }
}
