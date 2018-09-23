function [ c] = jmxcorrnp( a,b ) %c,t,max,tmax
a=double(a);b=double(b);
[l0,l]=size(a);[m0,m]=size(b);

if l0>l;l=l0;a=a';end

if m0>m;m=m0;b=b';end

if m>l;a0=b;l0=m;b=a;m=l;a=a0;l=l0;end

c=mxcorrCudaf(a,b,l,m)';

return
