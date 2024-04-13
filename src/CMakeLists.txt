



file(GLOB Keccak_SRCS Keccak/*.cu)
message(STATUS "Keccak sources: ${Keccak_SRCS}")



add_library(cucrypto SHARED  ${Keccak_SRCS})
target_include_directories(cucrypto PRIVATE ${CMAKE_SOURCE_DIR}/include)


add_executable(test_keccak tests/test_keccak.cu)
target_include_directories(cucrypto PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(test_keccak PRIVATE cucrypto)




