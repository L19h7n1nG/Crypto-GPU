#include <cstdint>
#include "Keccak.cuh"

namespace keccak {

template <int C, int D>
__global__ void keccak_hash_kernel(
        uint8_t* input,
        int      input_block_size,
        int      number_of_blocks,
        uint8_t* output) {
    int bid = threadIdx.x + blockDim.x * blockIdx.x;
    if (bid >= number_of_blocks)
        return;

    const int r_bits = 1600 - C;
    const int r_bytes = r_bits / 8;
    const int d_bytes = D / 8;

    uint8_t* b_input = input + bid * input_block_size;
    uint8_t* b_output = output + bid * d_bytes;
    uint64_t state[25] = {};

    int input_len = input_block_size;

    while (input_len >= r_bytes) {
        // #pragma unroll
        for (int i = 0; i < r_bytes; i += 8) {
            state[i / 8] ^= *(uint64_t*)(b_input + i);
        }
        keccakf(state);
        b_input += r_bytes;
        input_len -= r_bytes;
    }

    // last block (if any)
    uint8_t last_block[r_bytes];
    for (int i = 0; i < input_len; i++) {
        last_block[i] = b_input[i];
    }

    // pad 10*1
    last_block[input_len] = 1;
    for (int i = 0; i < r_bytes - input_len - 1; i++) {
        last_block[input_len + i + 1] = 0;
    }
    // last bit
    last_block[r_bytes - 1] |= 0x80;

    // #pragma unroll
    for (int i = 0; i < r_bytes; i += 8) {
        state[i / 8] ^= *(uint64_t*)(last_block + i);
    }
    keccakf(state);

#pragma unroll
    for (int i = 0; i < d_bytes; i += 8) {
        *(uint64_t*)(b_output + i) = state[i / 8];
    }
}

template <int C, int D>
cudaError_t keccak_hash(
        uint8_t*            input,
        int                 input_block_size,
        int                 number_of_blocks,
        uint8_t*            output,
        const KeccakConfig& config) {
    CHK_INIT_IF_RETURN();

    auto& stream = config.ctx.stream;

    uint8_t *input_device{nullptr}, *output_device{nullptr};
    if (config.are_inputs_on_device)
        input_device = input;
    else {
        CHK_IF_RETURN(cudaMallocAsync(
                &input_device, number_of_blocks * input_block_size, stream));
        CHK_IF_RETURN(cudaMemcpyAsync(
                input_device,
                input,
                number_of_blocks * input_block_size,
                cudaMemcpyHostToDevice,
                stream));
    }

    if (config.are_outputs_on_device)
        output_device = output;
    else
        CHK_IF_RETURN(cudaMallocAsync(
                &output_device, number_of_blocks * (D / 8), stream));

    int number_of_threads = 1024;
    int number_of_gpu_blocks = (number_of_blocks - 1) / number_of_threads + 1;

    keccak_hash_kernel<C, D>
            <<<number_of_gpu_blocks, number_of_threads, 0, stream>>>(
                    input_device,
                    input_block_size,
                    number_of_blocks,
                    output_device);

    if (!config.are_inputs_on_device)
        CHK_IF_RETURN(cudaFreeAsync(input_device, stream));

    if (!config.are_outputs_on_device) {
        CHK_IF_RETURN(cudaMemcpyAsync(
                output,
                output_device,
                number_of_blocks * (D / 8),
                cudaMemcpyDeviceToHost,
                stream));
        CHK_IF_RETURN(cudaFreeAsync(output_device, stream));
    }

    if (!config.is_async)
        return CHK_STICKY(cudaStreamSynchronize(stream));
    return CHK_LAST();
}

extern "C" cudaError_t Keccak256(
        uint8_t* input,
        int      input_block_size,
        int      number_of_blocks,
        uint8_t* output) {
    auto config = KeccakConfig::default_keccak_config();
    return keccak_hash<512, 256>(
            input, input_block_size, number_of_blocks, output, config);
}
} // namespace keccak
