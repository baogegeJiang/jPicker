#include "mex.h"
#include "math.h"
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *x,*y;
    double R1=0,R=0,dR1=0,dR=0,E=0,a=0,b=0;
    double C1=0.5,C2=0.1,C3=0.1,C4=0.01;
    int lx;
    x = mxGetPr(prhs[0]);
    //b = mxGetPr(prhs[1]);
    lx=*(mxGetPr(prhs[1]));
    //lb=*(mxGetPr(prhs[3]));
    int i,j;
    double ta,tb=0,tc;
    plhs[0]=mxCreateDoubleMatrix(lx,1,mxREAL);
    y= mxGetPr(plhs[0]);
    y[0]=0;
    for (i=1;i<lx;i++)
{
     R=C1*R+x[i]-x[i-1];
     dR=C2*(x[i]-x[i-1]);
     E=R*R+dR*dR;
     a=a+C3*(E-a);
     b=b+C4*(E-b);
    if(b==0)
    y[i]=0;
    else
    y[i]=a/b;
}
    return;
}


