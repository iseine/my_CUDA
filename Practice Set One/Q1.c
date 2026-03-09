#include <stdio.h>

__global__ void hello_from_gpu()
{
    printf("Block %d/%d,Thread %d/%d says hello!\n",
        blockIdx.x, gridDim.x, threadIdx.x, blockDim.x);
}

int main()
{
	hello_from_gpu <<<4, 3>>>();
	cudaDeviceSynchronize();
	return 0;
}
