%machineIsPhaseSCV4 machineIsPSCV3
setPara;
setPath;
for i=1:paraNum
velCheckFile=sprintf('%s/tool/tmpVEL/VELSVM%d/checkFile',workDir,i);
if exist(velCheckFile,'file');unix(['rm ',velCheckFile]);end
end
bTime=clock;

try delete(gcp('nocreate'));end
if paraNum>1;parpool('local',paraNum);end

for k=sDay:paraNum:eDay
%       if k<datenum(2008,7,15);continue;end

    if paraNum >1
       parfor i=k+[1:paraNum]-sDay
          if i-1+sDay>eDay;continue;end
          Day=i-1+sDay;
          temp=dayPick(Day,machineIsPhase,machineIsP);
          if size(temp)==0;isD(i)=0;continue;end
          isD(i)=1;day(i).quake=temp;
       end
    else
%       if k~=datenum(2016,4,6);continue;end
       for i=k+[1:paraNum]-sDay
           if i-1+sDay>eDay;continue;end
           Day=i-1+sDay;
           temp=dayPick(Day,machineIsPhase,machineIsP);
           if size(temp)==0;isD(i)=0;continue;end
           isD(i)=1;day(i).quake=temp;
        end
    end
    try 
       save dayTmp day
       fprintf('\n**********************\n used time: %.3f hours\n  save day in dayTmp      \n***********************\n',etime(clock,bTime)/3600);
    catch
       fprintf('no day mat\n');
    end
end
