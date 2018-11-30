data=rand(86400*50,3);
tic
parfor i=1:12
[peak,xd,A,slrZ,pre]=pickPeakAll(data,machineIsPhase,[]);
end
toc