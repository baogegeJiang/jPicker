function [ D]=oTimeD(quake)
D=-1*ones(length(quake),1);
for i=1:length(quake)
    oTimeCount=0;
    for j=1:length(quake(i).pTime)
        if quake(i).pTime(j)*quake(i).sTime(j)==0;continue;end
        if quake(i).sTime(j)- quake(i).pTime(j)>25/86400;continue;end
        oTimeCount=oTimeCount+1;
        oTime(oTimeCount)=calOTime(quake(i).pTime(j)*86400,quake(i).sTime(j)*86400);
    end
    if oTimeCount>=3;D(i)=var(oTime(1:oTimeCount));end
end
