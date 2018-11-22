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
const    int blocksPerGrid = 256;
const    int threadsPerBlock = 256;

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


__global__ void corr( float * a,float* b,  int la,int lb,float tb0,float* c,float *m,float *s,float *mb,float *sb) {
    int i=threadIdx.x+blockIdx.x*blockDim.x,j=0;
    int tid=threadIdx.x;
    float ta=0,tc=0;
    mb=mb+blockIdx.x*blockDim.x;
    sb=sb+blockIdx.x*blockDim.x;
    mb[tid]=0;sb[tid]=0;
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
        mb[tid]+=c[i];
        sb[tid]+=c[i]*c[i];
        i+=blockDim.x*gridDim.x;
    }
   __syncthreads();
   i=gridDim.x/2;
   while(i!=0){
     if(tid<i){
       mb[tid]+=mb[tid+i];//m[tid]/=2;
       sb[tid]+=sb[tid+i];//s[tid]/=2;
     }
     __syncthreads();
     i/=2;
     }    
      __syncthreads();
    if(tid==0){
     m[blockIdx.x]=mb[0];
     s[blockIdx.x]=sb[0];
     }
    return ;
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    float *a,*b,*c,*m,*s,mtmp[blocksPerGrid]={0},stmp[blocksPerGrid]={0};
    a = (float *) mxGetPr(prhs[0]);
    b = (float *) mxGetPr(prhs[1]);
    int la=*(mxGetPr(prhs[2]));
    int lb=*(mxGetPr(prhs[3]));
   
    plhs[0]=mxCreateNumericMatrix(la-lb+1,1, mxSINGLE_CLASS, mxREAL);
    c= (float *) mxGetPr(plhs[0]);
    float tb=0;
    for(int i=0;i<lb;i++){
        tb+=b[i]*b[i];
    }
    tb=sqrt(tb);
    
    float * d_a, *d_b,*d_c,*d_m,*d_s,*b_m,*b_s;
    cudaMalloc(&d_a, sizeof(float) * la);
    cudaMalloc(&d_b, sizeof(float) * lb);
    cudaMalloc(&d_c, sizeof(float) * (la-lb+1));
    cudaMalloc(&d_m, sizeof(float) *blocksPerGrid);    
    cudaMalloc(&d_s, sizeof(float) *blocksPerGrid);
    cudaMalloc(&b_m, sizeof(float) *blocksPerGrid*threadsPerBlock);
    cudaMalloc(&b_s, sizeof(float) *blocksPerGrid*threadsPerBlock);
   // printf("%f %f\n",mtmp[0],stmp[0]);
   
    cudaMemcpy(d_a, a, sizeof(float) * la, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(float) * lb, cudaMemcpyHostToDevice); 
    corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb,d_c,d_m,d_s,b_m,b_s);
    checkCUDAError("corr fail");
    cudaMemcpy(c, d_c, sizeof(float) * (la-lb+1), cudaMemcpyDeviceToHost);
    cudaMemcpy(mtmp, d_m, sizeof(float) *blocksPerGrid, cudaMemcpyDeviceToHost);
    cudaMemcpy(stmp, d_s, sizeof(float) *blocksPerGrid, cudaMemcpyDeviceToHost); 
    for(int i=1;i<blocksPerGrid;i++){
    mtmp[0]+=mtmp[i];stmp[0]+=stmp[i];
    }
    mtmp[0]/=(float)(la-lb+1);
    stmp[0]/=(float)(la-lb+1);
    stmp[0]=sqrt(stmp[0]-mtmp[0]*mtmp[0]);
     if( nlhs>=3){
      plhs[1]=mxCreateNumericMatrix(1,1, mxSINGLE_CLASS, mxREAL);
      plhs[2]=mxCreateNumericMatrix(1,1, mxSINGLE_CLASS, mxREAL);
      m= (float *) mxGetPr(plhs[1]);s= (float *) mxGetPr(plhs[2]);
      m[0]=mtmp[0];s[0]=stmp[0];
      la=la-lb+1;a=c;
      lb=*(mxGetPr(prhs[4]));
      float  mul=*(float *)(mxGetPr(prhs[5]));
      float tmin=m[0]+s[0]*mul;
      plhs[3]=mxCreateNumericMatrix(la-lb+1,1, mxSINGLE_CLASS, mxREAL);
      c= (float *)mxGetPr(plhs[3]);
      for( int i=0;i<la;i++)
      {
        if (i<la-lb+1) c[i]=a[i];
        if(a[i]>=tmin){
            for(int j=1;j<lb&&i-j>0&&i-j<la-lb+1;j++){
                if(a[i]>c[i-j]) c[i-j]=a[i];
          }

       }
     }


    }
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFree(d_m);
    cudaFree(d_s);
    cudaFree(b_m);
    cudaFree(b_s);
    return;
}
