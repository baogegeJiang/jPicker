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
