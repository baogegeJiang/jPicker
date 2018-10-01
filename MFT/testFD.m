for i=1:100
    a=rand(86400*100,1);
    b=rand(400,1);
    tic;jmxcorrnCudaff(a,b);toc;
    tic;jmxcorrnCuda(a,b);toc;
    max(abs(jmxcorrnCudaf(a,b)-jmxcorrnCuda(a,b)))
    fprintf('\n');
end