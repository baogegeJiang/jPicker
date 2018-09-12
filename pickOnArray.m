setPicker;
setPara;
setPicker;
for tmpDay=sDay:eDay
  %  matFile=sprintf('%s/sta_%dV3.mat',matDir,tmpDay);
%    load(matFile);
    count=tmpDay-sDay+1;
    for j=1:length(sta)
       [ pL,sL,sta(j) ] = pickOnSi( sta(j),machineIsPhase,machineIsP); 
        dayPhase(count).sta(j,1).timeCount=length(pL);
        dayPhase(count).sta(j,1).time=pL;
        dayPhase(count).sta(j,2).timeCount=length(sL);
        dayPhase(count).sta(j,2).time=sL;
    end
end
