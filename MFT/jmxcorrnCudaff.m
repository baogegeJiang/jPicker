function [ c] = jmxcorrnCudaff( a,b ) %c,t,max,tmax
if isa(a,'single')==0
    a=single(a);
end
if isa(b,'single')==0
    b=single(b);
end
[l0,l]=size(a);[m0,m]=size(b);
if l0>l;l=l0;end

if m0>m;m=m0;end

if m>l;a0=b;l0=m;b=a;m=l;a=a0;l=l0;end

c=mxcorrCudaff(a,b,l,m);

return
