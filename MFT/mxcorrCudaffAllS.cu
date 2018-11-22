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
    float *a0,*b0,*c0,*m,*s,mtmp[blocksPerGrid]={0},stmp[blocksPerGrid]={0},*addMat;
    a0 = (float *) mxGetPr(prhs[0]);
    b0 = (float *) mxGetPr(prhs[1]);
    int la0=*(mxGetPr(prhs[2]));
    int lb0=*(mxGetPr(prhs[3]));
    int lc0=*(mxGetPr(prhs[4]));
    int mul=*(float *)(mxGetPr(prhs[5]));
    int laout=*(mxGetPr(prhs[6]));
    int N=*(mxGetPr(prhs[7]));
    double *bIndex=mxGetPr(prhs[8]);
    plhs[0]=mxCreateNumericMatrix(laout,N, mxSINGLE_CLASS, mxREAL);
    plhs[1]=mxCreateNumericMatrix(1,N, mxSINGLE_CLASS, mxREAL);
    plhs[2]=mxCreateNumericMatrix(1,N, mxSINGLE_CLASS, mxREAL);
    plhs[3]=mxCreateNumericMatrix(laout,1, mxSINGLE_CLASS, mxREAL);
    float *addMatTmp=(float *)malloc(sizeof(float)*laout);
    m= (float *) mxGetPr(plhs[1]);s= (float *) mxGetPr(plhs[2]);
    addMat=(float *) mxGetPr(plhs[3]);
    c0= (float *) mxGetPr(plhs[0]);
    for(int i=0;i<laout;i++){
       addMat[i]=0;}
    for(int i=0;i<N;i++){
       for(int j=0;j<laout;j++){
          c0[i*laout+j]=0;
       }
    }
   
    float * d_a, *d_b,*d_c,*d_m,*d_s,*b_m,*b_s;

    cudaMalloc(&d_a, sizeof(float) * la0);
    cudaMalloc(&d_b, sizeof(float) * lb0);
    cudaMalloc(&d_c, sizeof(float) * (la0-lb0+1));
    cudaMalloc(&d_m, sizeof(float) *blocksPerGrid);    
    cudaMalloc(&d_s, sizeof(float) *blocksPerGrid);
    cudaMalloc(&b_m, sizeof(float) *blocksPerGrid*threadsPerBlock);
    cudaMalloc(&b_s, sizeof(float) *blocksPerGrid*threadsPerBlock);
   
    float *a,*b,*c;
    int la,lb;
    float tb=0,tmin;
    for (int index=0;index<10;index++){
        la=la0;lb=lb0;
        int bI=(int)-bIndex[index]+1; 
        if(bI<0) continue;
        a=a0+index*la;
        b=b0+index*lb;
        c=c0+index*laout;
        tb=0;
        //continue;
        for(int i=0;i<lb;i++){
           tb+=b[i]*b[i];
         }
         tb=sqrt(tb); 
        cudaMemcpy(d_a, a, sizeof(float) * la, cudaMemcpyHostToDevice);
        cudaMemcpy(d_b, b, sizeof(float) * lb, cudaMemcpyHostToDevice); 
        //continue;
        corr<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b,la,lb,tb,d_c,d_m,d_s,b_m,b_s);
        //continue;
        checkCUDAError("corr fail");
        //printf("%d %d\n",(int)(c-c0),bI);
        cudaMemcpy(c, d_c+bI, sizeof(float) * (la-lb+1-bI), cudaMemcpyDeviceToHost);
        cudaMemcpy(mtmp, d_m, sizeof(float) *blocksPerGrid, cudaMemcpyDeviceToHost);
        cudaMemcpy(stmp, d_s, sizeof(float) *blocksPerGrid, cudaMemcpyDeviceToHost); 
        //continue;
        for(int i=1;i<blocksPerGrid;i++){
           mtmp[0]+=mtmp[i];stmp[0]+=stmp[i];
        }
        mtmp[0]/=(float)(la-lb+1);
        stmp[0]/=(float)(la-lb+1);
        stmp[0]=sqrt(stmp[0]-mtmp[0]*mtmp[0]);
        m[index]=mtmp[0];s[index]=stmp[0];
        la=la-lb+1;a=c;
        lb=lc0;
        tmin=m[index]+s[index]*mul;
        c= addMatTmp;
        for( int i=0;i<la;i++)
        {
            if (i<la-lb+1) c[i]=a[i];
            if(a[i]>=tmin){
                for(int j=1;j<lb&&i-j>0&&i-j<la-lb+1;j++){
                if(a[i]>c[i-j]) c[i-j]=a[i];
             }

             }
         }
        for(int i=0;i<la-lb+1;i++) addMat[i]+=c[i];

    }
    for(int i=0;i<laout;i++)
       addMat[i]/=(float)N;
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFree(d_m);
    cudaFree(d_s);
    cudaFree(b_m);
    cudaFree(b_s);
    free(addMatTmp);
    return;
}
