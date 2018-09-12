#include "mex.h"
#include "math.h"
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *a,*c;
    int la,lb;
    a = mxGetPr(prhs[0]);
    la=*(mxGetPr(prhs[1]));
    lb=*(mxGetPr(prhs[2]));
    int i,j;
    double tmin;
    plhs[0]=mxCreateDoubleMatrix(la-lb+1,1,mxREAL);
    c= mxGetPr(plhs[0]);

    for( i=0;i<la-lb+1;i++)
    {
        
        if(i>0)
        {
          if(tmin != a[i-1])
          {
              if(tmin> a[i+lb-1]) c[i]=tmin;
              else {c[i]=a[i+lb-1];tmin=c[i];}
              continue;
          }
        }
        tmin=-1;
        for (j=0;j<lb;j++)
        {

            if(a[i+j]>tmin) tmin=a[i+j];
        }
        *(c+i)=tmin;
        }
    return;
}
