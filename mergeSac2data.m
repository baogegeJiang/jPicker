function [data,bSec,delta,eSec,bNum,eNum,isF]=mergeSac2data(sacEFile,sacNFile,sacZFile)
setPara;setPath;
sacDir=dataDir;
data=[];
bSec=[];
delta=[];
isF=0;
bSec=+inf;
bNum=+inf;
eSec=-inf;
eNum=-inf;
if strcmp(class(sacEFile),'cell')~=1;fprintf('no cell input');return;end
for i=1:length(sacEFile)
     sac(i).isF=1;
     sacE=readsac([sacDir,sacEFile{i}]);
     sacN=readsac([sacDir,sacNFile{i}]);
     sacZ=readsac([sacDir,sacZFile{i}]);
     if length(sacE)*length(sacN)*length(sacZ)==0
          sac(i).isF=0;continue;
     end
     [sac(i).data,sac(i).bSec,sac(i).delta,sac(i).eSec]=sac2data(sacE,sacN,sacZ); 
     if length(sac(i).data)==0;fprintf(' |bad record : %02d|  ',i);sac(i).isF=0;continue;end
     sac(i).bNum=datenum(sacE.NZYEAR,0,sac(i).bSec/(24*3600)); 
     sac(i).eNum=datenum(sacE.NZYEAR,0,sac(i).eSec/(24*3600));
     bSec=min(bSec,sac(i).bSec);
     bNum=min(bNum,sac(i).bNum);
     eSec=max(eSec,sac(i).eSec);
     eNum=max(eNum,sac(i).eNum);
     delta=sac(i).delta;
     isF=1;
end
L=ceil([bSec:delta:eSec]/delta);
data=zeros(length(L)+10,3,'single');
for i=1:length(sacEFile)
    if sac(i).isF==0;continue;end
    tmpL=ceil([sac(i).bSec:delta:sac(i).eSec]/delta);
    data(tmpL+1-L(1),:)=sac(i).data;
end
