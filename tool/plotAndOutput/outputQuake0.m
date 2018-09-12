phaseFile='/home/jiangyr/jSvm/phase0.csv';
phaseF={}; 
phaseCount=0;
dH=8;
maxDep=300;
minDT=10;2.0/86400;
maxPS=10;22.1900069000638208000/86400;;%19.53998/86400;
minMl=-10;%1.598;
minSta=3;3;
%la=[30.2,33.5];
%la=[28,40];
%lo=[100,110];
%lo=[102.2,106.4];
%minSLR=4;
for i=1:length(day)
  try 
      if length(day(i).quake)==0 || day(i).quake(1)==0;continue;end
  end
  for j=1:length(day(i).quake)
%     if day(i).quake(j).PS(1)==0;continue;end
    % if day(i).quake(j).PS(4)>80;continue;end 
 %    if  day(i).quake(j).PS(2)<la(1) || day(i).quake(j).PS(2)>la(2) ...
  %       ||  day(i).quake(j).PS(3)<lo(1) || day(i).quake(j).PS(3)>lo(2)
         %continue
       % day(i).quake(j).PS(2:3)
     %   continue;
   %  end 
     if sum(sign(day(i).quake(j).pTime))<=minSta;continue;end
   %  if day(i).quake(j).PS(5)<minMl;continue;end
   %  if day(i).quake(j).PS(4)>maxDep;continue;end
     for k=1:length(day(i).quake(j).pTime)
        if day(i).quake(j).pTime(k)<100;continue;end
       % if day(i).quake(j).slr(k)<minSLR;continue;end
%        if day(i).quake(j).pTime(k)-day(i).quake(j).PS(1)>maxPS/0.73;continue;end
       % if day(i).quake(j).sTime(k)-day(i).quake(j).pTime(k)>maxPS;continue;end
         tempTime=dH/24+day(i).quake(j).pTime(k);
         tempStr=datestr(tempTime,30);
         timeStr=[tempStr(1:8),tempStr(10:15)];
         msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));
         timeStr=[timeStr,'.',msecStr];
         temp=cutby(staLst(k).name,'.');
         staName=temp{2};
         phaseStr=[staName,',',timeStr,',','P'];
         phaseCount=phaseCount+1; 
         phaseF{phaseCount,1}=phaseStr;
 %       if day(i).quake(j).sTime(k)-day(i).quake(j).PS(1)>1.73*maxPS/0.73;continue;end
        if  day(i).quake(j).sTime(k)>100
          tempTime=dH/24+day(i).quake(j).sTime(k);
         tempStr=datestr(tempTime,30);
         timeStr=[tempStr(1:8),tempStr(10:15)];
         msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));
         timeStr=[timeStr,'.',msecStr];
         temp=cutby(staLst(k).name,'.');
         staName=temp{2};
         phaseStr=[staName,',',timeStr,',','S'];
         phaseCount=phaseCount+1;
         phaseF{phaseCount,1}=phaseStr;
       end
     end
 end
end
%phaseF{phaseCount+1,1}=['used time: ',num2str(etime(eTime,bTime)/60),' min; workstation; 14 cores 28 threads 128G memory'];
wfile(phaseF,phaseFile);
