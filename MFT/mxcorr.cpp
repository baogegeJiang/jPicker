#include "mex.h"
#include "math.h"
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*b,*c;
    int la,lb;
    a = mxGetPr(prhs[0]);
    b = mxGetPr(prhs[1]);
    la=*(mxGetPr(prhs[2]));
    lb=*(mxGetPr(prhs[3]));
    int i,j;
    double ta,tb=0,tc;
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);
    ta=0;
    for (i=0;i<lb;i++)
    {
        tb+=b[i]*b[i];
        ta+=a[i]*a[i];
    }
    tb=sqrt(tb);
    
    for( i=0;i<la-lb+1;i++)
    {
        tc=0;
        for (j=0;j<lb;j++)
        {
            tc+=a[i+j]*b[j];
        }
        if(i>0)
        {
            ta=ta-a[i-1]*a[i-1]+a[i+lb-1]*a[i+lb-1];
        }
        if (ta>0)
        *(c+i)=tc/(sqrt(ta)*tb);
        else
        *(c+i)=0;
    }
    return;
}
