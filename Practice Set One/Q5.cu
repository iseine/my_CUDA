#include<stdio.h>

__global__ void photo_plus(int *image)
{
	int tid_x = blockIdx.x * blockDim.x + threadIdx.x;
	int tid_y = blockIdx.y * blockDim.y + threadIdx.y;

	int tid_xy = 32 * tid_y + tid_x;

	image[tid_xy] += 1;
	/*一开始我写成这样image[tid_x][tid_y] += 1;但是我传过来的是拉直了的一维数组啊,不能用俩下标吧*/


	if (tid_x == 10) printf("(%d,%d):(%d*32+%d)+1=%d\n", tid_x, tid_y, tid_xy /32, tid_xy % 32, image[tid_xy]);
}

void initialize_data(int* image, int row, int col)
{
	int i, j;
	for (i = 0; i < row; i++)
	{
		for (j = 0; j < col; j++)
		{
			image[i*row+j] = i * 32 + j;
		}
	}
}
int main()
{
	int row = 32, col = 32;
	int array_byte = row * col * sizeof(int);
	int* h_image = (int*)malloc(array_byte);

	initialize_data(h_image, row, col);
	int* d_image;
	cudaMalloc((void**)&d_image, array_byte);
	
	cudaMemcpy(d_image, h_image, array_byte, cudaMemcpyHostToDevice);

	dim3 grid(2, 2), block(16, 16);
	photo_plus << <grid, block >> > (d_image);

	free(h_image);
	cudaDeviceSynchronize();
	cudaFree(d_image);
}