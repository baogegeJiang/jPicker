#include "mex.h"
#include "math.h"
#include <omp.h>
void cmax( float * a,int la,int lb,float* c,int threadN,int tid) {
    int si=tid;
    if(si>=la-lb+1) return;
    int i=si,j=0;
    float tmin; 
    for( ;i<la-lb+1;i+=threadN)
    {

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
    int la,lb;
    a =(float *) mxGetPr(prhs[0]);
    la=*(mxGetPr(prhs[1]));
    lb=*(mxGetPr(prhs[2]));
    int i,j;
    float tmin;
    plhs[0]=mxCreateNumericMatrix(la-lb+1,1, mxSINGLE_CLASS, mxREAL);
    c= (float *)mxGetPr(plhs[0]);
    int threadN=20;
    int loopN=(la-lb+1)/threadN+1;
   // omp_set_num_threads(threadN+1);
    #pragma omp parallel
   for(int i=0;i<threadN;i++){
      cmax(a,la,lb,c,threadN,i);
    //  printf("%d %d\n",omp_get_thread_num(),omp_get_num_threads());
}
      
}
