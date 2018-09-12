%function[quake]=plotQuake(sta,modPhase,modP,doAgain,quake,comp)
setPath;
setPara;
figureDir=[workDir,'output/quakeFigure/'];
if exist(figureDir,'file');
%   rmdir(figureDir,'s');
end
%mkdir(figureDir);
for dayIndex=1:length(day)
    quake=day(dayIndex).quake;
    tmpDay=dayIndex+sDay-1;
    tmpDay0=tmpDay-refDay+1;
    filename=sprintf('%ssta_%dV3.mat',matDir,tmpDay);
if exist(filename,'file')
%    load(filename);
else
    continue;
end
    clear quakeTmp
    qCount=0;
    for i=1:length(quake)
        if sum(sign(quake(i).pTime))<5;continue;end
        qCount=qCount+1;quakeTmp(qCount)=quake(i);
     end
    if qCount==0;continue;end
    plotQuake(sta,machineIsPhase,machineIsP,1,quakeTmp,3);
end
