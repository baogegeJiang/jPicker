function[ sacE ,sacN, sacZ]=sacFileName(net,station,comp,sDay0);
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
%/media/geodyn/1508282016033123/20160206.037.130000.000
%X2.15725.2016037130000.00.BHZ
%/dev/sdr2       3.6T  3.6T     0 100% /media/geodyn/1410090015032623
%/dev/sdq2       3.6T  2.2T  1.3T  65% /media/geodyn/1508282016033123
%/dev/sdk2       3.6T  3.4T   14G 100% /media/geodyn/1503270015082820
YM=YMD(1:6);
%2014.281.16.01.23.1739.GS.GTA.00.BHN.D.SAC
if strcmp(net,'NM') || strcmp(net,'GS')
   sacDirLst=sprintf('/home/jiangyr/sacDir/%s.%s/%s/',net,station,YM);
%   sprintf('%s/%s.%s*%s.%s.*.%sE.D.SAC',sacDirLst,Y,dayS,net,station,comp)
%fprintf('%s/%s.%s.%s.%sE.SAC',sacDirLst,net,station,YMD,comp)
   fileLst=dir(sprintf('%s/%s.%s.%s.%sE.SAC',sacDirLst,net,station,YMD,comp));
   if length(fileLst)==0;sacE=cell(1,1);sacE{1}='';sacN=sacE;sacZ=sacE;return;end
   for i=1:length(fileLst)
       sacE{i}=[sacDirLst,fileLst(i).name];
   end

 fileLst=dir(sprintf('%s/%s.%s.%s.%sN.SAC',sacDirLst,net,station,YMD,comp));
   if length(fileLst)==0;sacE=cell(1,1);sacE{1}='';sacN=sacE;sacZ=sacE;return;end
   for i=1:length(fileLst)
       sacN{i}=[sacDirLst,fileLst(i).name];
   end

  fileLst=dir(sprintf('%s/%s.%s.%s.%sZ.SAC',sacDirLst,net,station,YMD,comp));
   if length(fileLst)==0;sacE=cell(1,1);sacE{1}='';sacN=sacE;sacZ=sacE;return;end
   for i=1:length(fileLst)
       sacZ{i}=[sacDirLst,fileLst(i).name];
   end


return
end
sacDirL=length(sacDir);
sacDirLst={'/media/geodyn/1410090015032623/','/media/geodyn/1508282016033123/','/media/geodyn/1503270015082820/'};
for i=1:24
for j=1:3
hourSacDir=[sacDirLst{j},'/',YMD,'.',dayS,'.',sprintf('%02d',i-1),'0000.000/'];
temp=dir([hourSacDir,net,'.',station,'.',Y,dayS,'*.',comp,'E*']);
sacE{i+(j-1)*24}=[hourSacDir(sacDirL+1:end),temp.name];
temp=dir([hourSacDir,net,'.',station,'.',Y,dayS,'*.',comp,'N*']);
sacN{i+(j-1)*24}=[hourSacDir(sacDirL+1:end),temp.name];
temp=dir([hourSacDir,net,'.',station,'.',Y,dayS,'*.',comp,'Z*']);
sacZ{i+(j-1)*24}=[hourSacDir(sacDirL+1:end),temp.name];
end
end
