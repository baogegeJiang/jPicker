#include "mex.h"
using namespace std;
#include <cstdio>
#include <cuda_runtime.h>
using namespace std;
void checkCUDAError(const char *msg)   
{   
    cudaError_t err = cudaGetLastError();   
    if( cudaSuccess != err)    
    {   
        fprintf(stderr, "Cuda error: %s: %s.\n", msg,    
                                  cudaGetErrorString( err) );   
        exit(EXIT_FAILURE);   
    }                            
}  

// Kernel 函数
__global__ void cmax( double* a, int la,int lb,double* c) {
    int idx = threadIdx.x+blockIdx.x*blockDim.x;
    c[1]=1;
   // printf("%d",idx);
    int i=idx,j=0;
    double tmpMax;
    while (i < la-lb+1) {
        tmpMax=a[i];
        for(j=1;j<lb;j++){
           tmpMax=max(tmpMax,*(a+i+j));
        }
       *(c+i)=tmpMax;
       i+=blockDim.x*gridDim.x;
    }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*c;
    int la,lb;
    a = mxGetPr(prhs[0]);
    la=*(mxGetPr(prhs[1]));
    lb=*(mxGetPr(prhs[2]));
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    double* d_a,*d_c;
    cudaMalloc(&d_a, sizeof(double) * la);
    cudaMalloc(&d_c, sizeof(double) * (la-lb+1));
    cudaMemcpy(d_a, a, sizeof(double) * la, cudaMemcpyHostToDevice);
    checkCUDAError("memcpy");
    // 执行Kernel
    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    cmax<<<blocksPerGrid, threadsPerBlock>>>(d_a,la,lb,d_c);
    checkCUDAError("corr fail");
    cudaMemcpy(c, d_c, sizeof(double) * (la-lb+1), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_c);
    return;
}
