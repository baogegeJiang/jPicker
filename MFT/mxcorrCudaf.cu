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

__global__ void corr( float * a,float* b,  int la,int lb,float tb0,float* c) {
    int i=threadIdx.x+blockIdx.x*blockDim.x,j=0;
    float ta=0,tc=0;
   
    while (i < la-lb+1) {
        ta=0;tc=0;
        for(j=0;j<lb;j++){
          ta+=a[i+j]*a[i+j];
          tc+=a[i+j]*b[j];
        }
       *(c+i)=tc/(sqrtf(ta)*tb0);
          i+=blockDim.x*gridDim.x;
    }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*b,*c;
    a = mxGetPr(prhs[0]);
    b = mxGetPr(prhs[1]);
    const int la=*(mxGetPr(prhs[2]));
    const int lb=*(mxGetPr(prhs[3]));
    float tb=0;
    float *af,*bf,*cf;
    af=new float[la];
    bf=new float[lb];
    cf=new float[la-lb+1];
    for (int i=0;i<la;i++){
        af[i]=(float) a[i];}
    for (int i=0;i<lb;i++){
        bf[i]=(float) b[i];}
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    float* d_a, *d_b, *d_c;
    for(int i=0;i<lb;i++){
       tb+=bf[i]*bf[i];
    }
    tb=(float)sqrt((double)tb);
    cudaMalloc(&d_a, sizeof(float) * la);
    cudaMalloc(&d_b, sizeof(float) * lb);
    cudaMalloc(&d_c, sizeof(float) * (la-lb+1));
    cudaMemcpy(d_a, af, sizeof(float) * la, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, bf, sizeof(float) * lb, cudaMemcpyHostToDevice);
    checkCUDAError("memcpy");

    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb,d_c);
    checkCUDAError("corr fail");
    cudaMemcpy(cf, d_c, sizeof(float) * (la-lb+1), cudaMemcpyDeviceToHost);
    for(int i=0;i<la-lb+1;i++){
        c[i]=(double)cf[i];}
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    delete [] af;
    delete [] bf;
    delete [] cf;
    return;
}
