#include "mex.h"
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

__global__ void corr( double* a, double* b,   int la,int lb,double tb,double* c) {
    int idx = threadIdx.x+blockIdx.x*blockDim.x;
    int i=idx,j=0;
    double ta=0,tc=0;
    double tb0=sqrt(tb);
    while (i < la-lb+1) {
        ta=0;tc=0;
        for(j=0;j<lb;j++){
          ta+=a[i+j]*a[i+j];
          tc+=a[i+j]*b[j];
        }
       *(c+i)=tc/(sqrt(ta)*tb0);
          i+=blockDim.x*gridDim.x;
    }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*b,*c;
    int la,lb;
    a = mxGetPr(prhs[0]);
    b = mxGetPr(prhs[1]);
    la=*(mxGetPr(prhs[2]));
    lb=*(mxGetPr(prhs[3]));

    double tb=0;
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    double* d_a, *d_b, *d_c;
    for(int i=0;i<lb;i++){
       tb+=b[i]*b[i];
    }
    cudaMalloc(&d_a, sizeof(double) * la);
    cudaMalloc(&d_b, sizeof(double) * lb);
    cudaMalloc(&d_c, sizeof(double) * (la-lb+1));
    cudaMemcpy(d_a, a, sizeof(double) * la, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(double) * lb, cudaMemcpyHostToDevice);
    checkCUDAError("memcpy");

    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb,d_c);
    checkCUDAError("corr fail");
    cudaMemcpy(c, d_c, sizeof(double) * (la-lb+1), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return;
}
