setPath;
setPara;
global quake0G;
minSta=8;
quake0File=[workDir,'/tool/locFunc/quake0.mat'];
quake0=[];tmpCount=[];
for tmpDay=day
    for tmpQuake=tmpDay.quake
        if sum(sign(tmpQuake.pTime))>minSta
           quake0=[quake0 tmpQuake];tmpCount=[sum(sign(tmpQuake.pTime))+1000*sign(tmpQuake.PS(1)) tmpCount];
        end
    end
end
if length(quake0)<600;fprintf('not enough quakes (<600)\n');return;end
%save(quake0File,'quake0');
[v tmpL]=sort(-tmpCount);
quake0=quake0(tmpL(1:600));
%quake0G=quake0;
[loc res]=locQuake(quake0,1.5);
tmpCount=zeros(1,length(quake0));
for i=1:length(quake0)
    tmpCount(i)=-res(i)*3+1000*sign(loc(1,i))+sum(sign(quake0(i).pTime));
end
[v tmpL]=sort(-tmpCount);
quake0G=quake0(tmpL(1:200));
quake0=quake0G;
save(quake0File,'quake0');
