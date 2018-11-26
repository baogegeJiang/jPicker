function[quake]=reDetQuake(sta,modPhase,modP,doAgain,quake)
%% to reDetermine the phases' arrival time for each quake
toDoLst=[1,1,1,1];
global netPG netSG;
isPhaseA=[0:0];
minDT=2/86400;minDT0=2/86400;
delta=0.02;
quake0=quake;
if doAgain>=0;quake=betterQuake(quake);end
loc=locQuake(quake,2);
 for i=1:length(quake)
    if loc(1,i)==0;quake(i)=quake0(i);continue;end
    for j=1:length(sta)

        if sta(j).isF==0;quake(i).pTime(j)=0;quake(i).sTime(j)=0;continue;end
        try
        pTime=taupnet(netPG,[loc(2:4,i);sta(j).la;sta(j).lo],1)/86400+loc(1,i);
        sTime=taupnet(netSG,[loc(2:4,i);sta(j).la;sta(j).lo],2)/86400+loc(1,i);
        catch
        continue;
        end
          if  1%abs(quake(i).pTime(j)-pTime)>minDT||(sTime-quake(i).sTime(j) >minDT||quake(i).sTime(j)-sTime>0.05*(sTime-pTime))|| loc(4,i)<=0||loc(4,i)>50;
                  toDoLst=[2,1,2,1];
              if abs(quake(i).pTime(j)-pTime)>minDT0
                  toDoLst=[2,1,2,1];
              elseif (sTime-quake(i).sTime(j) >minDT0||quake(i).sTime(j)-sTime>0.2*(sTime-pTime));
                  toDoLst=[2,1,2,1];
          end
           if loc(4,i)<=0||loc(4,i)>50;toDoLst=[2,1,2,1];end
           bNum=sta(j).bNum;bNumN=floor(bNum);bNumM=bNum-bNumN;
           if pTime<bNum || sTime>bNum+length(sta(j).data)*delta/86400;continue;end
           bSec=bNumM*3600*24;
           pTime=(pTime-bNumN)*86400;sTime=(sTime-bNumN)*86400;
           pIndex=ceil((pTime-bSec)/delta+1);
           if pIndex<1000 || pIndex>length(sta(j).data)-1000;continue;end
           if max(max(abs(sta(j).data(pIndex+[-3:3]))))==0;continue;end
           sIndex=ceil((sTime-bSec)/delta+1);
           if max(max(abs(sta(j).data(sIndex+[-3:3]))))==0;continue;end
           pTime0=quake(i).pTime(j);sTime0=quake(i).sTime(j);
           [quake(i).pTime(j),quake(i).sTime(j)]=pPicker(pIndex,sIndex,sta(j),toDoLst,modPhase,modP);
       end
    end
  end
if doAgain==0;return;end
quake=reDetQuake(sta,modPhase,modP,doAgain-1,quake);
