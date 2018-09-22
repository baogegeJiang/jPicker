#include "mex.h"
#include "math.h"
#include <iostream>
#include <omp.h>
using namespace std;
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*b,*c;
    int la,lb;
    a = mxGetPr(prhs[0]);
    b = mxGetPr(prhs[1]);
    la=*(mxGetPr(prhs[2]));
    lb=*(mxGetPr(prhs[3]));
   // double *ta=new double(la);
  // double *tc=new double(la);
    double ta=0;
    double tc=0;
    
    int i,j;
    double tb=0;
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    ta=0;
    for (i=0;i<lb;i++)
    {
        tb+=b[i]*b[i];
        ta+=a[i]*a[i];
    }
    tb=sqrt(tb);
    omp_set_num_threads(10);
    int loopN=(int)((la-lb+1)/50)+1;
    int iii=0;
#pragma omp parallel for private(ta,tc,iii) num_threads(20)
//mex CXXFLAGS="$CXXFLAGS -fopenmp" LDFLAGS="$LDFLAGS -fopenmp" MFT/mxcorrP.cpp
for(int ii=0;ii<50;ii++)
{
    iii=((i-1)*loopN);
    for( i=ii;i<la-lb+1 &i<i+loopN ;i++)
    {
    //    cout<< omp_get_thread_num()<< " "<< omp_get_num_threads()<<endl;
        tc=0;
        ta=0;
        for (j=0;j<lb;j++)
        {
            tc+=a[i+j]*b[j];
            ta+=a[i+j]*a[i+j];
        }
        *(c+i)=tc/(sqrt(ta)*tb);
    }
}
    return;
}
