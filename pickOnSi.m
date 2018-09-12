function [ pL,sL,sta ] = pickOnSi( sta,modPhase,modP )
delta=0.02;
maxPS=30;
b=sta.bNum;
pL=[];sL=[];
pTime=0;sTime=0;nextTime=0;
[tmp peak]=getdetec(sta.pre(500:end),0,50);
peak=peak*delta+499*delta;
peak=sta.peak;
maxSN=40;
%[pTime,sTime,pre]=pPicker(pIndex,sIndex,sta,toDoLst,modPhase,modP);
for i=1:length(peak)
    
    if peak(i)<nextTime;continue;end
    pTime=peak(i);sTime=0;nextTime=pTime+maxPS;
    pIndex=ceil(peak(i)/delta);
    for j=i+1:length(peak)
        if peak(j)>pTime+maxPS;break;end
        sIndex=ceil(peak(j)/delta);
        xd=conXDF(pIndex,sIndex,sta.data);
        isP=preT(xd,modP);
        if isP>0;continue;end
        sTime=peak(j);
        break;
    end
    if sTime~=0
       [pTime,sTime,sta.pre]=pPicker(pIndex,sIndex,sta,[1,1,1],modPhase,modP);
       if pTime~=0 
           pL(end+1)=pTime;
       end
       if sTime~=0 
           sL(end+1)=sTime;
           nextTime=(sTime-b)*86400+maxSN;
           
       end
    else
        [pTime,sTime,sta.pre]=pPicker(pIndex,pIndex+500,sta,[1,1,0],modPhase,modP);
       if pTime~=0 
           pL(end+1)=pTime;
       end
    end
    fprintf('%s: %.2f s\n',sta.name,(pTime-sta.bNum)*86400);
    
end
end
