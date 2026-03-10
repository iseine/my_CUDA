#include<stdio.h>

__global__ void double_array(int *array)
{
	int i = threadIdx.x;
	int j;
	j = array[i] * 2;

	printf("%d ", j);
}

int main()
{
	int array[32] = {};
	for (int i = 0; i < 32; i++)
	{
		array[i] = i + 1;
	}
	int dev = 1;
	cudaSetDevice(dev);

	int* array_gpu;
	cudaMalloc((int**)&array_gpu, 32*sizeof(int));
	cudaMemcpy(array_gpu, array, 32 * sizeof(int), cudaMemcpyHostToDevice);

	double_array<<<1,32>>> (array_gpu);

	cudaDeviceSynchronize();

	return 0;

}