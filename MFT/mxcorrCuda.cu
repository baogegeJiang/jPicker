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

__global__ void corr( double* a,double* b,  int la,int lb,double tb0,double* c) {
    int i=threadIdx.x+blockIdx.x*blockDim.x,j=0;
    double ta=0,tc=0;
   
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
    //double t0,t1;
   // int la,lb;
    a = mxGetPr(prhs[0]);
    b = mxGetPr(prhs[1]);
    const int la=*(mxGetPr(prhs[2]));
    const int lb=*(mxGetPr(prhs[3]));
   // double *ta=new double(la);
  // double *tc=new double(la);
    double tb=0;
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    double* d_a, *d_b, *d_c;
    for(int i=0;i<lb;i++){
       tb+=b[i]*b[i];
    }
    tb=sqrt(tb);
    //t0=(double)clock();
    cudaMalloc(&d_a, sizeof(double) * la);
    cudaMalloc(&d_b, sizeof(double) * lb);
    cudaMalloc(&d_c, sizeof(double) * (la-lb+1));
    cudaMemcpy(d_a, a, sizeof(double) * la, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(double) * lb, cudaMemcpyHostToDevice);
    checkCUDAError("memcpy");
    //t1=(double)clock();
    //cout<< "mem assign "<<(t1-t0)/CLOCKS_PER_SEC<<endl;


    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    //t0=(double)clock();
    corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb,d_c);
    checkCUDAError("corr fail");
     //t1=(double)clock();
    //cout<< "cal assign "<<(t1-t0)/CLOCKS_PER_SEC<<endl;
    //t0=(double)clock();
    cudaMemcpy(c, d_c, sizeof(double) * (la-lb+1), cudaMemcpyDeviceToHost);
    //t1=(double)clock();
    //cout<< "mem back "<<(t1-t0)/CLOCKS_PER_SEC<<endl;
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return;
}