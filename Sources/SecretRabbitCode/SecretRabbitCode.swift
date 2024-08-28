import CSamplerate

public class SecretRabbitCode {
    public init() {}

    public func convertSampleRate(input: [Float], fromRate: Int, toRate: Int) -> [Float]? {
        var error: Int32 = 0
        let converter = src_new(Int32(SRC_SINC_BEST_QUALITY), 1, &error)
        guard error == 0 else { return nil }

        var data_out = [Float](repeating: 0, count: input.count * toRate / fromRate)
        var data_in = input.withUnsafeBufferPointer { buffer in 
            return data_out.withUnsafeMutableBufferPointer { buffer_out in
                return SRC_DATA(
                    data_in: buffer.baseAddress,
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
        src_delete(converter)
        guard error == 0 else { return nil }

        return data_out
    }
}