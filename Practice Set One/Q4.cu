#include<stdio.h>

__global__ void array_conclusion(int *arrayA,int *arrayB,int *arrayC,int N)
{
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	/*blockIdx编号是从0开始的,那范围就是0~255*/
	for (int i = tid; i < N; i += blockDim.x)
	{
		arrayC[i] = arrayA[i] + arrayB[i];
		printf("%d:%d+%d=%d\n", threadIdx.x,arrayA[i] , arrayB[i] ,arrayC[i]);
	}
	
}

void initial_data(int *array,int size)
{
	time_t t;
	srand((unsigned)time(&t));
	for (int i = 0; i < size; i++)
	{
		array[i] = rand() & 0xFF;
	}
}
/*
* 遇到了问题：关于rand函数，srand是决定后续所有rand的种子
* 0xFF掩码，意思是只保留八位，有时间可以多看看随机数写法
* d-arrayX是 CPU 上的一个指针变量，它的值是 GPU 显存的一块地址
*/
int main()
{
	int  N = 10;
	int* h_arrayA, * h_arrayB, * d_arrayA, * d_arrayB,*d_sum;

	int array_Byte = N * sizeof(int);

	h_arrayA = (int*)malloc(array_Byte);
	h_arrayB = (int*)malloc(array_Byte);

	initial_data(h_arrayA, N);
	initial_data(h_arrayB, N);

	cudaMalloc((void**)&d_arrayA, array_Byte);
	cudaMalloc((void**)&d_arrayB, array_Byte);
	cudaMalloc((void**)&d_sum, array_Byte);

	cudaMemcpy(d_arrayA, h_arrayA, array_Byte, cudaMemcpyHostToDevice);
	cudaMemcpy(d_arrayB, h_arrayB, array_Byte, cudaMemcpyHostToDevice);

	cudaMemset(d_sum, 0, array_Byte);


	array_conclusion << <1, 3 >> > (d_arrayA, d_arrayB, d_sum,N);

	cudaFree(d_arrayA);
	cudaFree(d_arrayB);
	cudaFree(d_sum);

	free(h_arrayA);
	free(h_arrayB);
	
	cudaDeviceSynchronize();

	return 0;

}
/*哈哈，一开始弄了1000个随机数，但是发现验证不了，给改成小数据了*/