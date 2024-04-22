


add_executable(test_keccak test_keccak.cu)
target_include_directories(test_keccak PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(test_keccak PRIVATE cucrypto)


add_subdirectory(thirdparty/cryptopp-cmake)


get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()





add_executable(test test.cc)
target_include_directories(test PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_include_directories(test PRIVATE ${cryptopp-cmake_BINARY_DIR})
target_link_directories(test PRIVATE ${cryptopp-cmake_BINARY_DIR}/cryptopp)

target_link_libraries(test PRIVATE cucrypto cryptopp)