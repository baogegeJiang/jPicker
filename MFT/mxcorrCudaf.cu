#include "mex.h"
#include <cstdio>
#include <cuda_runtime.h>
#include <ctime>
#include <iostream>
#include <math.h>
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
__global__ void double2float(double *ain,float *aout,int len){
    int i=threadIdx.x+blockIdx.x*blockDim.x;
    while(i<len){
        aout[i]=(float)ain[i];
        i+=blockDim.x*gridDim.x;
    }
    
}

__global__ void corr( float * a,float* b,  int la,int lb,float tb0,double* c) {
    int i=threadIdx.x+blockIdx.x*blockDim.x,j=0;
    float ta=0,tc=0;
    
    while (i < la-lb+1) {
        ta=0;tc=0;
        for(j=0;j<lb;j++){
            ta+=a[i+j]*a[i+j];
            tc+=a[i+j]*b[j];
        }
        
        *(c+i)=(double) tc/(sqrtf(ta)*tb0);
        if(ta==0){
           *(c+i)=0;
        }
        i+=blockDim.x*gridDim.x;
    }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*b,*c;
    float tb0f=0;
    a = mxGetPr(prhs[0]);
    b = mxGetPr(prhs[1]);
    const int la=*(mxGetPr(prhs[2]));
    const int lb=*(mxGetPr(prhs[3]));
    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    double tb=0;
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    
    for(int i=0;i<lb;i++){
        tb+=b[i]*b[i];
    }
    tb=sqrt(tb);tb0f=(float)tb;
    
    float * d_a, *d_b;
    double * dd_a, *dd_b,*d_c;
    cudaMalloc(&dd_a, sizeof(double) * la);
    cudaMalloc(&dd_b, sizeof(double) * lb);
    cudaMalloc(&d_a, sizeof(float) * la);
    cudaMalloc(&d_b, sizeof(float) * lb);
    cudaMalloc(&d_c, sizeof(double) * (la-lb+1));
    
    cudaMemcpy(dd_a, a, sizeof(double) * la, cudaMemcpyHostToDevice);
    cudaMemcpy(dd_b, b, sizeof(double) * lb, cudaMemcpyHostToDevice);
    double2float<<<blocksPerGrid, threadsPerBlock>>>(dd_a,d_a,la);
    double2float<<<blocksPerGrid, threadsPerBlock>>>(dd_b,d_b,lb);
    checkCUDAError("memcpy");
    
    
    corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb0f,d_c);
    checkCUDAError("corr fail");
    cudaMemcpy(c, d_c, sizeof(double) * (la-lb+1), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFree(dd_a);
    cudaFree(dd_b);
    
    return;
}
