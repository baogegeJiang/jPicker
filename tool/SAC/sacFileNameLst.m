function[ sacE ,sacN, sacZ]=sacFileName(net,station,comp,sDay0);
setPara;
setPath;
sacDir=dataDir;
dateStr=datestr(sDay0,31);
Y=dateStr(1:4);
sDay=sDay0-refDay+1;
dayS=num2str(sDay);
temp=dir([sacDir,net,'.',station,'.',Y,dayS,'*.',comp,'E*']);
sacE=[temp.name];
temp=dir([sacDir,net,'.',station,'.',Y,dayS,'*.',comp,'N*']);
sacN=[temp.name];
temp=dir([sacDir,net,'.',station,'.',Y,dayS,'*.',comp,'Z*']);
sacZ=[temp.name];

