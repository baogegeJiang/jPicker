#include "mex.h"
#include <cstdio>
#include <cuda_runtime.h>
#include <ctime>
#include <iostream>
#include <math.h>
using namespace std;
//plhs[0] = mxCreateNumericMatrix(2, 3, mxSINGLE_CLASS, mxREAL);
// fill in plhs[0] to contain the same as single([1 2 3; 4 5 6]); 
//  float * data = (float *) mxGetData(plhs[0]);
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


__global__ void corr( float * a,float* b,  int la,int lb,float tb0,float* c) {
    int i=threadIdx.x+blockIdx.x*blockDim.x,j=0;
    float ta=0,tc=0;
    
    while (i < la-lb+1) {
        ta=0;tc=0;
        for(j=0;j<lb;j++){
            ta+=a[i+j]*a[i+j];
            tc+=a[i+j]*b[j];
        }
        
        *(c+i)= tc/(sqrtf(ta)*tb0);
        if(ta==0){
           *(c+i)=0;
        }
        i+=blockDim.x*gridDim.x;
    }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    float *a,*b,*c;
    a = (float *) mxGetPr(prhs[0]);
    b = (float *) mxGetPr(prhs[1]);
    const int la=*(mxGetPr(prhs[2]));
    const int lb=*(mxGetPr(prhs[3]));
    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    plhs[0]=mxCreateNumericMatrix(la-lb+1,1, mxSINGLE_CLASS, mxREAL);
    c= (float *) mxGetPr(plhs[0]);
    float tb=0;
    for(int i=0;i<lb;i++){
        tb+=b[i]*b[i];
    }
    tb=sqrt(tb);
    
    float * d_a, *d_b,*d_c;
    cudaMalloc(&d_a, sizeof(float) * la);
    cudaMalloc(&d_b, sizeof(float) * lb);
    cudaMalloc(&d_c, sizeof(float) * (la-lb+1));
    
    cudaMemcpy(d_a, a, sizeof(float) * la, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(float) * lb, cudaMemcpyHostToDevice); 
    corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb,d_c);
    checkCUDAError("corr fail");
    cudaMemcpy(c, d_c, sizeof(float) * (la-lb+1), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return;
}
