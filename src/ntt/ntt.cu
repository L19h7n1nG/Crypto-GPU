#include "ntt.cuh"

namespace ntt {
extern "C" cudaError_t Ntt(
        uint8_t* input,
        int      input_block_size,
        int      number_of_blocks,
        uint8_t* output) {
    auto config = NttConfig::default_ntt_config();

    return cudaError_t::cudaSuccess;
}
} // namespace ntt