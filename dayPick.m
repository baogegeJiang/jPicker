function [quake]=dayPick(sDay0,machineIsPhase,machineIsP);
sacDir=[];
setPara;
setPath;
sDay=sDay0-refDay+1;
dayS=num2str(sDay);
clear sta
if globalSta==1
   global sta
end

staLst=[];
loadFile;
delta=0.02;
loadSta;
fprintf( 'working on %s day ', dayS);
perCount=0;
filename=sprintf('%ssta_%dV3.mat',matDir,sDay0);

if exist(filename,'file')
   load(filename);
else
   for i=1:length(staLst)
       sta(i).isF=0;sta(i).data=zeros(0,0,'single');sta(i).bSec=0;sta(i).delta=delta;sta(i).bNum=0;
       sta(i).peak=[];sta(i).xd=[];sta(i).A=[];sta(i).slrDataZ=[];sta(i).pre=single([]);
       sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
   end
end

for i=1:length(staLst)
    if exist(filename,'file')==0
       [sacEFile,sacNFile,sacZFile]=sacFileName(staLst(i).net,staLst(i).station,staLst(i).comp,sDay0);
      % fprintf( ' %d',i);
       sta(i).isF=0;
       [sta(i).data,sta(i).bSec,sta(i).delta,eSec,sta(i).bNum,eNum,sta(i).isF]=mergeSac2data(sacEFile,sacNFile,sacZFile);
    end
     fprintf( ' %d',i);
    bNumM=mod(sta(i).bNum,1);bNumN=floor(sta(i).bNum);
    if length(sta(i).data)<=20000;sta(i).isF=0;end
    if sta(i).isF==0;continue;end  
    [sta(i).peak,sta(i).xd,sta(i).A,sta(i).slrDataZ,sta(i).pre]=pickPeak(sta(i).data,machineIsPhase,sta(i).pre);
    sta(i).peak=sta(i).peak*delta+bNumM*3600*24;
    sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
    perCount=perCount+1;
end

if perCount<3;quake=[];return;end

fprintf('\nstart quake determine: ');

if saveSta>0
   save(filename,'sta','-v7.3');
end

for i=1:length(sta)
   sta(i).slrDataZ=[];
end

if globalSta==1
   quake=detQuake(1,machineIsPhase,machineIsP,reScan);
else
   quake=detQuake(sta,machineIsPhase,machineIsP,reScan);
end

end   
