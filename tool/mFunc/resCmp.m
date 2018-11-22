%load day1719;
%load day1202
%setPath;
%%outputQuake5;
%dayPhase0=readPhaseLst([workDir,'/someFile/phaseLst0'],datenum(2008,07,1));
dayPhase0=readPhaseLst([workDir,'/someFile/phase0.csv'],datenum(2008,07,1));
%dayPhase0=readPhaseLst('/home/jiangyr/jSvm/phase0.csv',datenum(2008,7,1));
%dayPhase=readPhaseLst([workDir,'/output/phaseLstALL'],datenum(2008,07,1));
loadSta;
clear phaseCmp cmp
phaseCount0=0;phaseCount=0;
minTimeDif=2/86400;noTimeV=minTimeDif;2/86400;
Lk=1;
phaseCmpP=[];
phaseCmpS=[];
clear phaseCmp;
for i=1:length(dayPhase)
    phaseCount=0;phaseCount0=0;
    for j=1:length(staLst)
        for k=Lk
            if dayPhase0(i).sta(j,k).timeCount==0;continue;end
               for l=1:dayPhase0(i).sta(j,k).timeCount 
%                   if dayPhase0(i).sta(j,k).time(l)<datenum(2008,7,1,8);continue;end
                   phaseCount0=phaseCount0+1;
                   phaseCmp(phaseCount0,1)=noTimeV;;
                   phaseCmp(phaseCount0,2)=j;
                   phaseCmp(phaseCount0,3)=k;
                   phaseCmp(phaseCount0,4)=dayPhase0(i).sta(j,k).time(l);
                   if dayPhase(i).sta(j,k).timeCount==0;
                      continue;
                   end
                   temp=dayPhase(i).sta(j,k).time-dayPhase0(i).sta(j,k).time(l);
                   [minTD,index]=min(abs(temp));
                   if k==1;phaseCmpP=[phaseCmpP;temp(index)];
                   else phaseCmpS=[phaseCmpS;temp(index)];end
                   if minTD <=minTimeDif;phaseCmp(phaseCount0,1)=temp(index);phaseCount=phaseCount+1;cmp(phaseCount)=temp(index)*86400;end
                  % if 0%mod(phaseCount,100)==0&& phaseCount~=0;fprintf('%.7f%% %.5f\n',...
                  %    100*phaseCount/phaseCount0,((phaseCmp(:,1)*86400)'*(phaseCmp(:,1)*86400)/phaseCount0)^0.5);end
               end
         end
    end
   resC(i)=100*phaseCount/phaseCount0;
   fprintf('per:%.2f%% m:%.3f d:%.3f\n',100*phaseCount/phaseCount0,mean(cmp),(cmp*cmp'/length(cmp))^0.5);
end
plot(phaseCmp(:,1)*86400,'.');
saveas(gcf,'resCmp.pdf');
