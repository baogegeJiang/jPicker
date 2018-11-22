M=8400000;
N=600;
a=single(rand(M,10));
b=single(rand(N,10));
for i=1:100
    i
tic;[x,m,s,tmp]=mxcorrCudaffAllSQ(a,b,M,N,10,single(3),M,10,-[0:10]*0);toc
tic;[x1,m1,s1,tmp1]=mxcorrCudaffAllS(a,b,M,N,10,single(3),M,10,-[0:10]*0);toc

%max(abs(tmp-tmp1);
end
% for i=1:100
% a=single(rand(M,1));
% b=single(rand(N,1));
% 
% tic;[x,m,s,tmp]=mxcorrCudaffAll(a,b,M,N,10,single(3));toc
% end
