



file(GLOB Keccak_SRCS Keccak/*.cu)
message(STATUS "Keccak sources: ${Keccak_SRCS}")
file(GLOB Ntt_SRCS ntt/*.cu)
message(STATUS "NTT sources: ${Ntt_SRCS}")


add_library(cucrypto SHARED  ${Keccak_SRCS} ${Ntt_SRCS})
target_include_directories(cucrypto PRIVATE ${CMAKE_SOURCE_DIR}/include)
set_property(TARGET cucrypto PROPERTY CUDA_ARCHITECTURES native)






add_subdirectory(tests)