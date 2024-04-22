cmake_minimum_required(VERSION 3.20)

project(crypto-gpu CXX CUDA)

set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")



message(STATUS ${CMAKE_SOURCE_DIR}/include)
add_executable(hello hello.cu)
target_include_directories(hello PRIVATE ${CMAKE_SOURCE_DIR}/include)
set_property(TARGET hello PROPERTY CUDA_ARCHITECTURES native)




add_subdirectory(src)

# file(GLOB )


