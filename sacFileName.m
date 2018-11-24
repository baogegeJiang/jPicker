function[ sacE ,sacN, sacZ]=sacFileName(net,station,comp,sDay0)
%sacE={'ABC.20150101.00.BHE.SAC','ABC.20150101.08.BHE.SAC','ABC.20150101.16.BHE.SAC'}
%sacN={'ABC.20150101.00.BHN.SAC','ABC.20150101.08.BHN.SAC','ABC.20150101.16.BHN.SAC'}
%sacZ={'ABC.20150101.00.BHZ.SAC','ABC.20150101.08.BHZ.SAC','ABC.20150101.16.BHZ.SAC'}
%comp: BH/HH/...
setPara;
setPath;
sacDir=dataDir;
dateStr=datestr(sDay0,30);
Y=dateStr(1:4);
YMD=dateStr(1:8);
yNum=datenum(str2num(Y),1,1);
sDay=sDay0-yNum+1;
dayS=sprintf('%03d',sDay);
clear temp dir
YM=YMD(1:6);
%2018.001.00.00.00.0000.JP.JCJ..BHE.M.SAC
YMD=YMD(1:4);
sacE=cell(0,0);
%sprintf('%s/%s.%s.*.%s.%s.%sE.M.SAC',sacDir,YMD,dayS,net,station,comp)
fileLst=dir(sprintf('%s/%s.%s.*.%s.%s..%sE.M.SAC',sacDir,YMD,dayS,net,station,comp));
for i=1:length(fileLst)
    sacE{i}=fileLst(i).name;
end
sacN=cell(0,0);
fileLst=dir(sprintf('%s/%s.%s.*.%s.%s..%sN.M.SAC',sacDir,YMD,dayS,net,station,comp));
for i=1:length(fileLst)
    sacN{i}=fileLst(i).name;
end
sacZ=cell(0,0);
fileLst=dir(sprintf('%s/%s.%s.*.%s.%s..%sZ.M.SAC',sacDir,YMD,dayS,net,station,comp));
for i=1:length(fileLst)
    sacZ{i}=fileLst(i).name;
end

