#ifndef __CUCRYPTO_H__
#define __CUCRYPTO_H__

#include <cstdint>



extern "C" int Keccak256(
        uint8_t* input,
        int      input_block_size,
        int      number_of_blocks,
        uint8_t* output,
        bool     are_inputs_on_device = false,
        bool     are_output_on_device = false,
        bool     async = false);


#endif