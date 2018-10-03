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


__global__ void cmax( float * a,int la,int lb,float* c,int loopN) {
    int si=(threadIdx.x+blockIdx.x*blockDim.x)*loopN;
    if(si>=la-lb+1) return;
    int i=si,j=0,ei=si+loopN; 
    float tmin; 
    for( ;i<la-lb+1&&i<ei;i++)
    {
      

        if(i>si)
        {
          if(tmin != a[i-1])
          {
              if(tmin> a[i+lb-1]) c[i]=tmin;
              else {c[i]=a[i+lb-1];tmin=c[i];}
              continue;
          }
        }
       
        tmin=-999999;
        for (j=0;j<lb;j++)
        {

            if(a[i+j]>tmin) tmin=a[i+j];
        }
        *(c+i)=tmin;
        }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    float *a,*c;
    a = (float *) mxGetPr(prhs[0]);
    const int la=*(mxGetPr(prhs[1]));
    const int lb=*(mxGetPr(prhs[2]));
    int blocksPerGrid = 256;
    int threadsPerBlock = 256;
    plhs[0]=mxCreateNumericMatrix(la-lb+1,1, mxSINGLE_CLASS, mxREAL);
    c= (float *) mxGetPr(plhs[0]);
    
    float * d_a,*d_c;
    cudaMalloc(&d_a, sizeof(float) * la);
    cudaMalloc(&d_c, sizeof(float) * (la-lb+1));
    
    cudaMemcpy(d_a, a, sizeof(float) * la, cudaMemcpyHostToDevice);
    int loopN=(la-lb+1)/(blocksPerGrid*threadsPerBlock)+1;
  //  printf("%d",loopN);
   // return;
    cmax<<<blocksPerGrid, threadsPerBlock>>>(d_a,la,lb,d_c,loopN);
    checkCUDAError("corr fail");
    cudaMemcpy(c, d_c, sizeof(float) * (la-lb+1), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_c);
    return;
}
