setPath;
setPara;
figureDir=[workDir,'output/quakeFigure/'];
if exist(figureDir,'file');
%   rmdir(figureDir,'s');
end
%mkdir(figureDir);
for dayIndex=1:length(day)
fclose('all');
    dayIndex
    for i=1:length(day(dayIndex).quake)
        if day(dayIndex).quake(i).PS(1)>100
           tmpDay=floor(day(dayIndex).quake(i).PS(1));
        break;
        end
    end   
    sacDir=[];
    dayS=num2str(tmpDay);
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
     filename=sprintf('%ssta_%dV3_100.mat',matDir,tmpDay);

      if exist(filename,'file')
          continue;
      %   load(filename);continue;end
      else
         for i=1:length(staLst)
         sta(i).isF=0;sta(i).data=zeros(0,0,'single');sta(i).bSec=0;sta(i).delta=delta;sta(i).bNum=0;
         sta(i).peak=[];sta(i).xd=[];sta(i).A=[];sta(i).slrDataZ=[];sta(i).pre=single([]);
         sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
          end
       end

        for i=1:length(staLst)
%       fprintf( '.');
%      if i==16;continue;end
 %      if i<=28;continue;end
       if exist(filename,'file')==0
          [sacEFile,sacNFile,sacZFile]=sacFileName(staLst(i).net,staLst(i).station,staLst(i).comp,tmpDay);
      % fprintf( ' %d',i);
          sta(i).isF=0;
          [sta(i).data,sta(i).bSec,sta(i).delta,eSec,sta(i).bNum,eNum,sta(i).isF]=mergeSac2data(sacEFile,sacNFile,sacZFile);
       end
          fprintf( ' %d',i);
          bNumM=mod(sta(i).bNum,1);bNumN=floor(sta(i).bNum);
       if length(sta(i).data)<=20000;sta(i).isF=0;end
       if sta(i).isF==0;continue;end
       sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
       perCount=perCount+1;
    end

    if perCount<3;quake=[];continue;end
     quakeTmp=day(dayIndex).quake;
     getWaveform(sta,quakeTmp);
    if saveSta>0
     save(filename,'sta','-v7.3');
     end
end
