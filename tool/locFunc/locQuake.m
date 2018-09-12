function[loc,res]=locQuake(quake,locPara)
% quake { pTime sTime PS }; locPara: different parameters in locating 

NS='NS';
EW='EW';
loc=0;loc0=[];
dmax=500;
isJLoc=0;
setPara;
if isJLoc==1;
    loc=zeros(4,length(quake));
    res=zeros(1,length(quake));
   global staLstG;
   staLst=staLstG;
   for i=1:length(quake)
       [loc(:,i),res(i)]=jLoc(quake(i),staLst,1);
   end
   return
end
   
maxQuake=30;
maxQuake1=20;

if length(quake)>maxQuake;
quakeOri=quake;
quake=quakeOri(1:maxQuake1);
[loc0,res0]=locQuake(quakeOri(maxQuake1+1:length(quakeOri)),locPara);
end
maxIT='100';
if locPara==3;maxIT='40';locPara=2;end
if locPara==2;maxQuake=30;maxQuake1=20;end

global velNG
velN=velNG;
%velN
if length(velN)==0;velN=1;fprintf('no specific VELNG\n');end
setPath;
velDir=sprintf('%s/tool/tmpVEL/VELSVM%d/',workDir,velN);
file=[velDir,'calarea7.cnv'];
runStr=['bash ',velDir,'matrun.bash ',velDir,'velest3'];
locFile=[velDir,'vel_reloc.CNV'];
locFile1=[velDir,'vel_reloc.CNV1'];
cmnFile=[velDir,'velest.cmn'];
tmp_cmnFile=[velDir,'tmp_velest.cmn'];
checkFile=[velDir,'checkFile'];
quakeF=cell(1,1);
quakeCount=0;
quakeIndex=0;
fCount=0;
minSta1=3;
minSta2=5;
l0=length(quake); 
loc=zeros(4,l0,'double');
res=ones(1,l0)*999;
load phaseMat
global quake0G
quake0=quake0G;

try
quakeTmp(length(quake)+[1:length(quake0)])=quake0;
quakeTmp(1:length(quake))=quake;
quake=quakeTmp;
catch
return;
end

global staLstG;
staLst=staLstG;
if length(staLst)<=5;load staLst;end
oTimeLst=zeros(length(quake),1);

for i=1:length(quake)

    fCount0=fCount;

	if i<=l0 && sum(sign(quake(i).pTime))<minSta1;continue;end
	if i>l0 && sum(sign(quake(i).pTime))<minSta2;continue;end

	firstSta=1;oTime=0;firstP=inf;
    
    if i>l0;quake(i).pTime=(quake(i).pTime-2000).*sign(quake(i).pTime);quake(i).sTime=(quake(i).sTime-2000).*sign(quake(i).sTime);end
	
    for j=1:min(length(quake(i).pTime),length(staLst))
        if quake(i).pTime(j)==0||quake(i).sTime(j)==0||quake(i).pTime(j)>firstP;
            continue;
        end
        firstP=quake(i).pTime(j);firstSta=j;
        oTime=min(calOTime(quake(i).pTime(j),quake(i).sTime(j)),quake(i).pTime(j)-10/86400);
    end

    if oTime<datenum(10,1,1)|| oTime>datenum(10000,1,1);continue;end

    oTimeLst(i)=oTime;
    temp=datestr(oTime,30);
    YMD=temp(3:8);
    HM=temp(10:13);
    sec=(oTime*1440-floor(oTime*1440))*60;
    fCount=fCount+1;
    quakeCount=quakeCount+1;
    quakeIndex(quakeCount)=i;
    laTmp=staLst(firstSta).la+0.2*(rand-0.5);
    loTmp=staLst(firstSta).lo+0.2*(rand-0.5);
    depTmp=rand*5+10;
 %   if quake(i).PS(1)~=0;oTimeLst(i)=quake(i).PS(1);end
    if quake(i).PS(2)~=0;laTmp=quake(i).PS(2);end
    if quake(i).PS(3)~=0;loTmp=quake(i).PS(3);end
    if quake(i).PS(4)~=0;depTmp=min(max(5,quake(i).PS(4)),10+20*rand);end
    quakeF{fCount,1}=sprintf('%s %s %5.2f %7.4f%s %8.4f%s    %4.2f  %5.2f    %3d  0.0 0.03  1.0  1.0',YMD,HM,sec,...
    abs(laTmp),NS(1.5-sign(laTmp)/2),abs(loTmp),EW(1.5-sign(loTmp)/2),...
    depTmp,quake(i).PS(5),i);
    temp=[];

    if quake(i).PS(1)==0;ela=staLst(firstSta).la;elo=staLst(firstSta).lo;dep=10;;else;ela= quake(i).PS(2);elo=quake(i).PS(3);dep=min(100,max(5,floor(quake(i).PS(4))));end
    phaseCount=0;

    for j=1:min(length(quake(i).pTime),length(staLst))
        [dk,dd,a,b]=distaz(ela,elo,staLst(j).la,staLst(j).lo);
    	if quake(i).pTime(j)==0 || abs(quake(i).pTime(j)-oTime)>500/86400;continue;end
        if quake(i).pTime(j)<oTime;continue;end
        phaseCount=phaseCount+1;
        if dk<phaseMat(dep)
            temp=[temp,sprintf('%sP0%6.2f',staLst(j).nick,(quake(i).pTime(j)-oTime)*86400)];
        else
            temp=[temp,sprintf('%sP1%6.2f',staLst(j).nick,(quake(i).pTime(j)-oTime)*86400)];
        end
     	if mod(phaseCount,6)==0;fCount=fCount+1;quakeF{fCount,1}=temp;temp=[];end
    end

    for j=1:min(length(quake(i).pTime),length(staLst))
    	if quake(i).sTime(j)==0 || abs(quake(i).sTime(j)-oTime)>500/86400;continue;end
        if quake(i).sTime(j)<oTime;continue;end
    	phaseCount=phaseCount+1;
        if dk<phaseMat(dep)
            temp=[temp,sprintf('%sS0%6.2f',staLst(j).nick,(quake(i).sTime(j)-oTime)*86400)];
        else
            temp=[temp,sprintf('%sS1%6.2f',staLst(j).nick,(quake(i).sTime(j)-oTime)*86400)];
        end
        if mod(phaseCount,6)==0;fCount=fCount+1;quakeF{fCount,1}=temp;temp=[];end
    end

    if mod(phaseCount,6)~=0;fCount=fCount+1;quakeF{fCount,1}=temp;temp=[];end
    
    fCount=fCount+1;quakeF{fCount,1}=' ';temp=[];

    if phaseCount<=4;fCount=fCount0;quakeF=quakeF(1:fCount,:);quakeCount=quakeCount-1;end

end    

fCount=fCount+1;quakeF{fCount,1}='9999';

while 1
    if exist(checkFile,'file')==0;break;end
    pause(2);
end

wfile({'1'},checkFile);
wfile(quakeF,file);
textCmn=readdata(tmp_cmnFile);
textCmn{14,1}=num2str(quakeCount);
textCmn{11,1}=num2str(la0);
textCmn{11,2}=num2str(-lo0);
textCmn{38,2}=maxIT;
if locPara>0;textCmn{20,1}=num2str(dmax);end
if locPara==2||locPara==1.5;textCmn{23,2}=num2str(1);end
wfile(textCmn,cmnFile);
cd(velDir);
unix(runStr);
cd(workDir);
%140823 1514 38.34 40.2115N 116.6039E    8.00   2.90    838  0.0 0.03  1.0  1.0
%AIAIP0  0.00AIAIS0 11.77ALALP0-17.06ALALS0 -5.54AQAQP0-11.94AQAQS0  2.80
%BCBCP0 -6.31BCBCS0 10.14AHAHP0 -1.61AHAHS0 20.49
% 8 731 1645 51.48 32.3429N 104.9482E  -0.01   2.90     88      4.43
%ACACP0  4.65ADADP0 28.67AEAEP0 32.81AGAGP0 25.05AIAIP0 23.19AJAJP0  2.67
%ALALP0 23.77ANANP0 28.41ACACS0  7.77ADADS0 48.97AEAES0 57.17AGAGS0 44.31
%AIAIS0 40.45AJAJS0  8.31ALALS0 40.09ANANS0 48.51

unix(['cp ',locFile,' ',locFile1]);
fp=fopen(locFile1);

line=textread(locFile,'%s','delimiter','\n','whitespace','');

unix(['rm ',checkFile]);
for i=1:length(line)
    temp=line{i,1};
    if length(temp) ~= 67;continue;end
    oTime=datenum(2000+str2num(temp(1:2)),str2num(temp(3:4)),str2num(temp(5:6)),str2num(temp(8:9)),str2num(temp(10:11)),str2num(temp(13:17)));
    [m,id]=min(abs(oTimeLst-oTime));
    if id>l0;continue;end
    if m>500/86400;continue;end
    
    loc(1,id)=oTime;
    loc(2,id)=str2num(temp(18:25));
    loc(3,id)=str2num(temp(28:35));
    loc(4,id)=str2num(temp(37:43));
    try res(1,id)=str2num(temp(62:67));end
    if temp(26)=='S';loc(2,id)=-loc(2,id);end
    if temp(36)=='W';loc(3,id)=-loc(3,id);end
end
if length(loc0)>1;loc=[loc,loc0];res=[res,res0];end
fclose all;
return

