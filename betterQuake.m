function [quake]=betterQuake(quake)
%to drop some bad phases' arrival time
for i=1:length(quake)
	if sum(sign(quake(i).pTime))<4;continue;end
        if sum(sign(quake(i).sTime))<3;continue;end
	tmpQuake=quake(i);qCount=0;
	for j=length(tmpQuake.pTime):-1:1
            if tmpQuake.pTime(j)==0;continue;end
%            if abs(tmpQuake.pTime(j)-tmpQuake.sTime(j))<12/86400;continue;end
            qCount=qCount+1;jL(qCount)=j;
	    quakeT(qCount)=tmpQuake;
	    quakeT(qCount).pTime=tmpQuake.pTime-0.1*j*sign(tmpQuake.pTime);
	    quakeT(qCount).sTime=tmpQuake.sTime-0.1*j*sign(tmpQuake.sTime);
            quakeT(qCount).PS(1)=tmpQuake.PS(1)-0.1*j;
	    quakeT(qCount).pTime(j)=0;quakeT(qCount).sTime(j)=0;
	end
    qCount=qCount+1;quakeT(qCount)=tmpQuake;
	[loc,res]=locQuake(quakeT(1:qCount),2);res0=res(qCount);
	[res,minJ]=min(abs(res));
    if res~=999 && minJ~=qCount && (loc(minJ)>0 || loc(qCount)<=0)&& res<res0-0.75
        quake(i).pTime(jL(minJ))=0;quake(i).sTime(jL(minJ))=0;
        if res<3 && loc(4,minJ) <= 40+rand*20
        quake(i).PS(2:4)=loc(2:4,minJ);
        end
    end
end
