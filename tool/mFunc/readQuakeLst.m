function[day]=readQuakeLst(filePath,sDay,dayPhase)
addpath(genpath('/home/jiangyr/mattaup'));
sacDir='/DATA/jiangyr/AIPICK/after2/';
fkModelFile='/home/jiangyr/mattaup/fk.tvel';
modelLocalMat='/home/jiangyr/mattaup/modelLocal.mat';
netPFile='/home/jiangyr/mattaup/netP.mat';
netSFile='/home/jiangyr/mattaup/netS.mat';
global velNG
velNG=mod(sDay,12)+1;
load(netPFile);load(netSFile);
global netPG;global netSG;
netPG=netP;netSG=netS;

load(modelLocalMat);
global modelLocalG
modelLocalG=modelLocal;

clear staLst
loadSta;
global staLstG
staLstG=staLst;
    
global quake0G;
load quake0;
quake0G=quake0;
           
load netPhase;
global netPhaseG;
netPhaseG=netPhase;
clear quake0 modelLocal

delta=0.02;
loadSta;

    global netPG netSG;
    line=textread(filePath,'%s','delimiter','\n','whitespace','');
    for i=1:length(line)
        temp=cutby(line{i},',');
        phaseCell(i,1:length(temp))=temp;
    end
    loadSta;
    maxDayCount=0;
    for i=1:length(phaseCell)
        dateStr=phaseCell{i,1};
        if strcmp(dateStr(1),'2')==0;continue;end
        dayNum=datenum(str2num(dateStr(1:4)),str2num(dateStr(5:6)),str2num(dateStr(7:8)),str2num(dateStr(9:10)),str2num(dateStr(11:12)),...
        str2num(dateStr(13:end)))-8/24;
        dayCount=ceil(dayNum)-sDay;
        if dayCount<=0;continue;end
        if dayCount>maxDayCount
           day(dayCount).quakeCount=0;
           maxDayCount=dayCount;
        end
        la=str2num(phaseCell{i,2});
        lo=str2num(phaseCell{i,3});
        quakeCount=day(dayCount).quakeCount+1;
        day(dayCount).quakeCount=quakeCount;
        day(dayCount).quake(quakeCount).la=la;
        day(dayCount).quake(quakeCount).lo=lo;
        day(dayCount).quake(quakeCount).dep=5;
        day(dayCount).quake(quakeCount).pTime=zeros(length(staLst),1);
        day(dayCount).quake(quakeCount).sTime=zeros(length(staLst),1);
        for j=1:length(staLst)
            try
                pTime=taupnet(netPG,[la;lo;5;staLst(j).la;staLst(j).lo],1)/86400+dayNum;
                sTime=taupnet(netSG,[la;lo;5;staLst(j).la;staLst(j).lo],2)/86400+dayNum;
            catch
                1
                continue;
            end
            if dayPhase(dayCount).sta(j,1).timeCount~=0;
               DT=dayPhase(dayCount).sta(j,1).time-pTime;
               [minDT,minIndex]=min(abs(DT));
               if minDT<6/86400;
                  day(dayCount).quake(quakeCount).pTime(j)=dayPhase(dayCount).sta(j,1).time(minIndex);
               end
            end
            if dayPhase(dayCount).sta(j,2).timeCount~=0;
               DT=dayPhase(dayCount).sta(j,2).time-sTime;
               [minDT,minIndex]=min(abs(DT));
               if minDT<6/86400;
                  day(dayCount).quake(quakeCount).sTime(j)=dayPhase(dayCount).sta(j,2).time(minIndex);
               end
            end
         end 
    end
end
