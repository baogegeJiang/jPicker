setPath;
clear staLst
staFile=[workDir,'staLst'];
staF=readdata(staFile);
ABC='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopgrstuvwxyz';
lABC=length(ABC);
for i=1:size(staF,1)
%staLst(i).name=staF{i,1};
staLst(i).lo=str2num(staF{i,4});
staLst(i).la=str2num(staF{i,5});
%temp=cutby(staLst(i).name,'.');
staLst(i).net=staF{i,1};
staLst(i).station=staF{i,2};
staLst(i).comp=staF{i,3};
staLst(i).name=[staLst(i).station];
m=mod(i,lABC);n=(i-m)/lABC+1;
staLst(i).nick=[ABC(n),ABC(m+1),ABC(n),ABC(m+1)];
end

save staLst staLst
