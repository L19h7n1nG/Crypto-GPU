#include <iostream>

#include <helper_cuda.h>

__global__ void myKernel(void) {}

int main(void) {
    myKernel<<<1, 1>>>();
    printf("Hello CUDA!\n");

    std::cout << gpuGetMaxGflopsDeviceId() << '\n';
    return 0;
}