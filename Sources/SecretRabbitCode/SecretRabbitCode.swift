import CSamplerate

public class SecretRabbitCode {
    private var converter: OpaquePointer?
    private var error: Int32 = 0

    public init?(
        converterType: Int32 = Int32(SRC_LINEAR),
        channels: Int32 = 1
    ) {
        self.converter = src_new(converterType, channels, &error)
        guard error == 0 else {
            SecretRabbitCode.printError(error)
            return nil
        }
    }

    deinit {
        src_delete(converter)
    }

    public func convertSampleRate(input: [Float], fromRate: Int, toRate: Int) -> [Float]? {
        var data_out = [Float](repeating: 0, count: input.count * toRate / fromRate)
        var data_in = input.withUnsafeBufferPointer { buffer_in in
            return data_out.withUnsafeMutableBufferPointer { buffer_out in
                return SRC_DATA(
                    data_in: buffer_in.baseAddress,
                    data_out: buffer_out.baseAddress,
                    input_frames: input.count,
                    output_frames: input.count * toRate / fromRate,
                    input_frames_used: 0,
                    output_frames_gen: 0,
                    end_of_input: 0,
                    src_ratio: Double(toRate) / Double(fromRate)
                )
            }
        }

        error = src_process(converter, &data_in)

        guard error == 0 else {
            SecretRabbitCode.printError(error)
            return nil
        }

        return data_out
    }

    static func printError(_ error: Int32) {
        let errorString = String(cString: src_strerror(error))
        print("SRC error: \(errorString)")
    }
}
