%20080512160312.2,32.01,104.01
setPath;
phaseFile=[workDir,'/output/phaseLstALL'];
quakeFile=[workDir,'/output/quakeLst'];
quakeF={};
phaseF={}; 
phaseCount=0;
dH=0;
%minDT=2.5/86400;
minMl=-10;
minSta=1;
qCount=0;
for i=1:length(day)
%     for j=1:length(day(i).quake);day(i).quake(j).PS=zeros(5,1);end
%    loc=locQuake(day(i).quake,1.5);
  for j=1:length(day(i).quake)
       [coverRate,coverL,errLa,errLo] =calCover(day(i).quake(j), staLst);
%      day(i).quake(j).PS(1:4)=loc(:,j);
%     if day(i).quake(j).PS(1)==0;continue;end      
%     if sum(sign(day(i).quake(j).pTime(1:28)))<=minSta;continue;end 
%      if sum(sign(day(i).quake(j).pTime(1:28)))<2||sum(sign(day(i).quake(j).pTime(29:46)))<2;continue;end
     qCount=qCount+1;
     phaseCount=phaseCount+1;
     tempTime=day(i).quake(j).PS(1)+dH/24;
     tempStr=datestr(tempTime,30);
     timeStr=[tempStr(1:8),tempStr(10:15)];
     msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));
     timeStr=[timeStr,'.',msecStr];
     phaseF{phaseCount,1}=sprintf('quake %d : %s la: %.3f  lo: %.3f  dep: %.3f ml: %.3f coverR: %.2f errLa: %.2f errLo: %.2f',qCount,timeStr,day(i).quake(j).PS(2:5),coverRate,errLa,errLo);
%     quakeF{qCount,1}=sprintf('AI%s %s %s %s %s %s %s %.2f %.2f %.2f %.2f',timeStr(1:14),timeStr(1:4),timeStr(5:6),timeStr(7:8),...
%timeStr(9:10),timeStr(11:12),timeStr(13:17),day(i).quake(j).PS(3),day(i).quake(j).PS(2),day(i).quake(j).PS(4:5));
      quakeF{qCount,1}=sprintf('%s,%.2f,%.2f numP:%d',timeStr,day(i).quake(j).PS(2),day(i).quake(j).PS(3),sum(day(i).quake(j).pTime(102:end)>0));
%timeStr(9:10),timeStr(11:12),timeStr(13:17),day(i).quake(j).PS(3),day(i).quake(j).PS(2),day(i).quake(j).PS(4:5));
     for k=1:length(day(i).quake(j).pTime)
        if day(i).quake(j).pTime(k)<100;continue;end
  %      if sta(k).isF==0;continue;end
        if day(i).quake(j).PS(5)<minMl;continue;end
         tempTime=dH/24+day(i).quake(j).pTime(k);
         tempStr=datestr(tempTime,30);
         timeStr=[tempStr(1:8),tempStr(10:15)];
         msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));
         timeStr=[timeStr,'.',msecStr];
         temp=cutby(staLst(k).name,'.');
         %staName=temp{2};
         staName=staLst(k).name;
         phaseStr=[staLst(k).net,'.',staName,',',timeStr,',','P'];
         phaseCount=phaseCount+1; 
         phaseF{phaseCount,1}=phaseStr;
       if day(i).quake(j).sTime(k)<100;continue;end
         tempTime=dH/24+day(i).quake(j).sTime(k);
         tempStr=datestr(tempTime,30);
         timeStr=[tempStr(1:8),tempStr(10:15)];
         msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));
         timeStr=[timeStr,'.',msecStr];
         temp=cutby(staLst(k).name,'.');
         %staName=temp{2};
         staName=staLst(k).name;
         phaseStr=[staLst(k).net,'.',staName,',',timeStr,',','S'];
         phaseCount=phaseCount+1;
         phaseF{phaseCount,1}=phaseStr;
     end
 end
end
%phaseF{phaseCount+1,1}=['used time: ',num2str(etime(eTime,bTime)/60),' min; workstation; 14 cores 28 threads 128G memory'];
wfile(phaseF,phaseFile);
wfile(quakeF,quakeFile);
