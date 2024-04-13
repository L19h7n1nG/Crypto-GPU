#ifndef __CUCRYPTO_H__
#define __CUCRYPTO_H__

namespace keccak {

extern "C" cudaError_t Keccak256(
        uint8_t* input,
        int      input_block_size,
        int      number_of_blocks,
        uint8_t* output);
} // namespace keccak

#endif