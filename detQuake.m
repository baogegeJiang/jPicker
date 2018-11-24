function[quake]=detQuakeV6(sta,modPhase,modP,doAgain)
%% the main function to detect earthquakes and determine their arrival time

dd1=0.1;dd2=0.05;dd3=0.05;
dd1=0.1;
maxRes=1.5;dTimeE=2;
setPara;
if globalSta==1;clear sta;global sta;end
if doAgain<reScan
dd1=0.1;
fprintf('set dd1=0.1\n');
end
toDoLst=[1,1,1,1];
global netPG netSG;
global timeLstG;
timeLst=timeLstG;
warning off all
minDT=1/86400;minDT0=1/86400;
delta=0.02;
secC=zeros(25*3700,length(sta),nR,mR,'uint8');
secCMin=zeros(25*3700,length(sta),nR,mR,'uint16');
secCMax=zeros(25*3700,length(sta),nR,mR,'uint16');
minDet=2.9;minD=30;minIsP=0;

dLa=(R(2)-R(1))/nR;dLo=(R(4)-R(3))/mR;La=R(1):dLa:R(2);Lo=R(3):dLo:R(4);

%% find every stations' possible phase pairs and  stack them.
for i =1:length(sta)
    if sta(i).isF==0;continue;end
    fprintf('%d ',i);
    sta(i).pair=pairPick(sta(i).peak,sta(i).xd,sta(i).A,modP,sta(i).data,sta(i).bNum,delta);
    for j=1:size(sta(i).pair,1)
        secT=floor(sta(i).pair(j,1));
        for k=floor(secT+(-1)*dd1*min(max(10,abs(sta(i).pair(j,3)-sta(i).pair(j,2))),30)):floor(secT+1*dd1*min(max(10,abs(sta(i).pair(j,3)-sta(i).pair(j,2))),30))
           if k<=0 || k>length(secC)-100;continue;end
              for in=1:nR 
                  for im=1:mR
                      if abs(sta(i).pair(j,3)-sta(i).pair(j,2))+dTimeE>timeLst(in,im,i,1)&&abs(sta(i).pair(j,3)-sta(i).pair(j,2))-dTimeE<timeLst(in,im,i,2)
                      secC(k,i,in,im)=1;
                      if secCMin(k,i,in,im)~=0; secCMin(k,i,in,im)=min(secCMin(k,i,in,im),j);else;secCMin(k,i,in,im)=j;end
                      if secCMax(k,i,in,im)~=0; secCMax(k,i,in,im)=max(secCMax(k,i,in,im),j);else;secCMax(k,i,in,im)=j;end
                      end
                  end
              end
        end
     end
end
fprintf('\n');
secCS=sum(secC,2);
secCSMax=[max(max(secCS,[],3),[],4)];
[quakeN,quakeTime]=getdetec(secCSMax,minDet,minD);
fprintf('time detect find  %d\n',length(quakeTime));
if quakeTime(1)<=0;quake=[];return;end

for i=1:length(quakeTime)
    quake(i).pTime=zeros(length(sta),1,'double');
    quake(i).sTime=zeros(length(sta),1,'double');
    quake(i).PS=zeros(5,1,'double');
    tempTime=quakeTime(i);
    staN=secCSMax(tempTime);
    RMS=inf;
    for j=max(1,tempTime-4):length(secC)
        if j>=tempTime && secCSMax(j)<=max(2,staN-1);break;end
        if secCSMax(j)<=max(2,staN-1);continue;end
        tempRMS=0;
        tempTimeO=j+0.5;
        [tmpIN,tmpIM]=find(secCS(j,1,:,:)==secCSMax(j));
        tmpIN=mod(tmpIM(1)-1,nR)+1;
        tmpIM=ceil(tmpIM(1)/nR);
        for k=1:length(sta)
            if secC(j,k,tmpIN,tmpIM)==0;continue;end
            tempRMS1=10;indexT=0;
            for pairIndex=secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM)
                if  abs(sta(k).pair(pairIndex,3)-sta(k).pair(pairIndex,2))+dTimeE>timeLst(tmpIN,tmpIM,k,1)&&abs(sta(k).pair(pairIndex,3)-sta(k).pair(pairIndex,2))-dTimeE<timeLst(tmpIN,tmpIM,k,2)
                    RMS=(sta(k).pair(pairIndex,1)-tempTimeO).^2;
                    if RMS<tempRMS1
                      tempRMS1=RMS;
                      indexT=pairIndex;
                    end
                end
            end
           % [tempRMS1,indexT]=min((sta(k).pair(secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM),1)-tempTimeO).^2);
           % indexT=indexT+secCMin(j,k,tmpIN,tmpIM)-1;
            if indexT~=0&&tempRMS1<(dd2*(sta(k).pair(indexT,3)-sta(k).pair(indexT,2)))^2;tempRMS1=0;end
            tempRMS=tempRMS+tempRMS1;
           % [tempRMS1,indexT]=min((sta(k).pair(secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM),1)-tempTimeO).^2);
           % indexT=indexT+secCMin(j,k,tmpIN,tmpIM)-1;
           % if tempRMS1<(dd2*(sta(k).pair(indexT,3)-sta(k).pair(indexT,2)))^2;tempRMS1=0;end
           % tempRMS=tempRMS+tempRMS1;
        end
        tempRMS=tempRMS/(secCSMax(j)-1)^2;
        if tempRMS<RMS;tempTime=j;RMS=tempRMS;end
     end
     for tempTimeO=tempTime+[-0.3:0.1:1.3]
         j=max(1,floor(tempTimeO));
         %if secCS(j)<staN;break;end
         if secCSMax(j)<=max(2,staN-1);continue;end
         tempRMS=0;
         [tmpIN,tmpIM]=find(secCS(j,1,:,:)==secCSMax(j));
         tmpIN=mod(tmpIM(1)-1,nR)+1;
         tmpIM=ceil(tmpIM(1)/nR);
         for k=1:length(sta)
            if secC(j,k,tmpIN,tmpIM)==0;continue;end
            tempRMS1=10;indexT=0;
            for pairIndex=secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM)
                if  abs(sta(k).pair(pairIndex,3)-sta(k).pair(pairIndex,2))+dTimeE>timeLst(tmpIN,tmpIM,k,1)&&abs(sta(k).pair(pairIndex,3)-sta(k).pair(pairIndex,2))-dTimeE<timeLst(tmpIN,tmpIM,k,2)
                    RMS=(sta(k).pair(pairIndex,1)-tempTimeO).^2;
                    if RMS<tempRMS1
                      tempRMS1=RMS;
                      indexT=pairIndex;
                    end 
                end
            end
           % [tempRMS1,indexT]=min((sta(k).pair(secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM),1)-tempTimeO).^2);
           % indexT=indexT+secCMin(j,k,tmpIN,tmpIM)-1;
            if indexT~=0&&tempRMS1<(dd3*(sta(k).pair(indexT,3)-sta(k).pair(indexT,2)))^2;tempRMS1=0;end
            tempRMS=tempRMS+tempRMS1;
        end
        tempRMS=tempRMS/(secCSMax(j)-1)^2;
        if tempRMS<RMS;tempTime=tempTimeO;RMS=tempRMS;end
     end
     j=max(1,floor(tempTime));
     [tmpIN,tmpIM]=find(secCS(j,1,:,:)==secCSMax(j));
     tmpIN=mod(tmpIM(1)-1,nR)+1;
     tmpIM=ceil(tmpIM(1)/nR);
     tempTimeO=tempTime;
     pIndexMat=zeros(length(quake),length(sta));
     for k=1:length(sta)
         if secC(j,k,tmpIN,tmpIM)==0;quake(i).pTime(k)=0;quake(i).sTime(k)=0;continue;end
            tempRMS1=10;indexT=0;
            for pairIndex=secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM)
                if  abs(sta(k).pair(pairIndex,3)-sta(k).pair(pairIndex,2))+dTimeE>timeLst(tmpIN,tmpIM,k,1)&&abs(sta(k).pair(pairIndex,3)-sta(k).pair(pairIndex,2))-dTimeE<timeLst(tmpIN,tmpIM,k,2)
                    RMS=(sta(k).pair(pairIndex,1)-tempTimeO).^2;
                    if RMS<tempRMS1
                      tempRMS1=RMS;
                      indexT=pairIndex;
                    end
                end
            end
           % [tempRMS1,indexT]=min((sta(k).pair(secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM),1)-tempTimeO).^2);
           % indexT=indexT+secCMin(j,k,tmpIN,tmpIM)-1;
       %  [tempMin,index]=min((sta(k).pair(secCMin(j,k,tmpIN,tmpIM):secCMax(j,k,tmpIN,tmpIM))-tempTimeO).^2);
        % pairIndex=index+secCMin(j,k,tmpIN,tmpIM)-1;
         if indexT~=0
            pairIndex=indexT;
            pIndex=sta(k).pair(pairIndex,4);sIndex=sta(k).pair(pairIndex,5);
            pTime0=sta(k).peak(pIndex);
            for pIndexT=pIndex:-1:1
                if sta(k).peak(pIndexT)<pTime0-3;break;end
                pIndex=pIndexT;
            end
            quake(i).pTime(k)=sta(k).peak(pIndex);
            dateNum=floor(sta(k).peak(pIndex));
            pxd=sta(k).xd(:,pIndex);
            sTime0=sta(k).peak(sIndex);
            for sIndexT=sIndex:-1:1
                if sta(k).peak(sIndexT)<sTime0-3;break;end
                [isP,temp]=preT([pxd;sta(k).xd(:,sIndexT)],modP);
                if isP>0;continue;end
                if sta(k).A(sIndexT)<sta(k).A(pIndex)*0.2;continue;end
                sIndex=sIndexT;
            end
            pIndexMat(i,k)=pIndex;
            sIndexMat(j,k)=sIndex;
            quake(i).sTime(k)=sta(k).peak(sIndex);
          end
     end
    quake(i).PS=zeros(5,1);%quake(i).PS(1:4)=[tempTimeO/86400+dateNum;La(tmpIN)+rand*dLa;Lo(tmpIM)+rand*dLo;rand*20];
end

clear secC secCMin secCMax secCS secCSMax

fprintf('start to determine %d\n',length(quake));
qCount=0;
for i=1:length(quake)
    if sum(sign(quake(i).pTime))>3;qCount=qCount+1;end
    for j=1:length(sta)
    if sta(j).isF==0;continue;end
    if quake(i).pTime(j)==0;continue;end
    bNum=sta(j).bNum;bNumN=floor(bNum);bNumM=bNum-bNumN;
    bSec=bNumM*3600*24;
    pIndex=ceil((quake(i).pTime(j)-bSec)/delta+1);
    sIndex=ceil((quake(i).sTime(j)-bSec)/delta+1);
    if pIndex<1000 || pIndex>length(sta(j).data)-1000;continue;end
    [quake(i).pTime(j),quake(i).sTime(j),sta(j).pre]=pPicker(pIndex,sIndex,sta(j),[4,1,2,1],modPhase,modP);

    end
 end
if doLoc==0;return;end
fprintf('qCount %d\n',qCount);
loc=locQuake(quake,3);
tmpL=find(loc(1,:)~=0);
loc=loc(:,tmpL);
quake=quake(tmpL);

fprintf('first Loop %d\',length(find(loc(1,:)~=0)));
  for i=1:length(quake)
    if loc(1,i)==0;continue;end
    for j=1:length(sta)
       
        if sta(j).isF==0;continue;end     
        try
        pTime=taupnet(netPG,[loc(2:4,i);sta(j).la;sta(j).lo],1)/86400+loc(1,i);
        sTime=taupnet(netSG,[loc(2:4,i);sta(j).la;sta(j).lo],2)/86400+loc(1,i);
        catch
        continue;
        end
        if 1%abs(quake(i).pTime(j)-pTime)>minDT0||(sTime-quake(i).sTime(j) >minDT0
              toDoLst=[1,1,2,1];
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
           [quake(i).pTime(j),quake(i).sTime(j),sta(j).pre]=pPicker(pIndex,sIndex,sta(j),toDoLst,modPhase,modP);
           if quake(i).pTime(j)==0;quake(i).pTime(j)=pTime0;end
           if quake(i).sTime(j)==0;quake(i).sTime(j)=sTime0;end
        end 
    end
  end
  [loc res]=locQuake(quake,2);
  for i=1:size(loc,2)
   if res(i)<maxRes
      quake(i).PS(1:4)=loc(:,i);
   end
  end
%  betterL=find(sign((sign(loc(1,:)).*res)-maxRes)+1+sign(loc(4,:)-30)+1>0.5);
%  quake(betterL)=betterQuake(quake(betterL));
  
fprintf('second Loop %d\',length(find(loc(1,:)~=0)));

  for i=1:length(quake)
    if loc(1,i)==0;continue;end
    for j=1:length(sta)

        if sta(j).isF==0;continue;end
        try
        pTime=taupnet(netPG,[loc(2:4,i);sta(j).la;sta(j).lo],1)/86400+loc(1,i);
        sTime=taupnet(netSG,[loc(2:4,i);sta(j).la;sta(j).lo],2)/86400+loc(1,i);
        catch
        continue;
        end
          if 1%abs(quake(i).pTime(j)-pTime)>minDT||(sTime-quake(i).sTime(j)) >minDT
                  toDoLst=[1,1,2,1];
           if loc(4,i)<=0||loc(4,i)>50;toDoLst=[1,1,1,1];end
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
           [quake(i).pTime(j),quake(i).sTime(j),sta(j).pre]=pPicker(pIndex,sIndex,sta(j),toDoLst,modPhase,modP);
       end
    end
  end
  
  [loc res]=locQuake(quake,2);
  for i=1:size(loc,2)
    if res(i)<maxRes
       quake(i).PS(1:4)=loc(:,i);
    end
  end
  [loc res]=locQuake(quake,2);
  for i=1:size(loc,2)
      if res(i)<maxRes
         quake(i).PS(1:4)=loc(:,i);
      end
  end
  fprintf('third Loop %d\',length(find(loc(1,:)~=0)));
  for i=1:length(quake)
    if loc(1,i)==0;continue;end
    for j=1:length(sta)

        if sta(j).isF==0;continue;end
        try
        pTime=taupnet(netPG,[loc(2:4,i);sta(j).la;sta(j).lo],1)/86400+loc(1,i);
        sTime=taupnet(netSG,[loc(2:4,i);sta(j).la;sta(j).lo],2)/86400+loc(1,i);
        catch
        continue;
        end
          if 1%abs(quake(i).pTime(j)-pTime)>minDT||(sTime-quake(i).sTime(j) >minDT||quake(i).sTime(j)-sTime>0.05*(sTime-pTime))|| loc(4,i)<=0||loc(4,i)>50;
                  toDoLst=[3,1,2,1];
           if loc(4,i)<=0||loc(4,i)>50;toDoLst=[3,1,2,1];end
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
           [quake(i).pTime(j),quake(i).sTime(j),sta(j).pre]=pPicker(pIndex,sIndex,sta(j),toDoLst,modPhase,modP);
           if quake(i).pTime(j)~=0
              pIndex=ceil((quake(i).pTime(j)-sta(j).bNum)*86400/delta+1);
              sIndex=max(ceil((quake(i).sTime(j)-sta(j).bNum)*86400/delta+1),pIndex+250);
              psL=max(1,pIndex-250):min(length(sta(j).pre),1.5*sIndex-0.5*pIndex);
              try 
                 1;%sta(j).pre(psL)=sta(j).pre(psL)*0-10;
              end
           end
       end
    end
  end

if reDet==1
  quake=reDetQuake(sta,modPhase,modP,1,quake);
end

[loc res]=locQuake(quake,2);
for i=1:size(loc,2)
   if res(i)<maxRes
    quake(i).PS(1:4)=loc(:,i);
   end
end
[loc res]=locQuake(quake,2);
for i=1:size(loc,2)
   if res(i)<maxRes
      quake(i).PS(1:4)=loc(:,i);
   end
end
fprintf('final Loop %d\n',length(find(loc(1,:)~=0)));
qCount=0;
for i=1:length(quake)
    if loc(1,i)==0;
      continue;
      for j=1:length(quake(i).pTime)
        if sta(j).isF==0;continue;end
        if quake(i).pTime(j)==0;continue;end
        pIndex=ceil((quake(i).pTime(j)-sta(j).bNum)*86400/delta+1);
        sIndex=max(ceil((quake(i).sTime(j)-sta(j).bNum)*86400/delta+1),pIndex+250);
        psL=max(1,pIndex-250):min(length(sta(j).data),1.5*sIndex-0.5*pIndex);
        sta(j).data(psL,:)=sta(j).data(psL,:).*0;
      end
      continue;
    end
    qCount=qCount+1;
    quake0(qCount)=quake(i);
    ml=0;mCount=0;
    for j=1:length(quake(i).pTime)
        if sta(j).isF==0;continue;end
        if quake(i).pTime(j)==0;continue;end
        pIndex=ceil((quake(i).pTime(j)-sta(j).bNum)*86400/delta+1);
        sIndex=max(ceil((quake(i).sTime(j)-sta(j).bNum)*86400/delta+1),pIndex+250);
        dk=distaz(sta(j).la,sta(j).lo,loc(2,i),loc(3,i));
        dk=max(10,dk);
        if sIndex-50>0 && sIndex+300<length(sta(j).data);sA=getSA(sta(j).data(sIndex+[-50:300],:))*delta;else sA=0;end
        if sA~=0 && dk >10 && dk <550;mCount=mCount+1;ml=ml+max(-1,log10(sA)+1.1*log10(dk)+0.00189*dk-2.09-0.23);end
        psL=max(1,pIndex-250):min(length(sta(j).data),1.5*sIndex-0.5*pIndex);
        sta(j).data(psL,:)=sta(j).data(psL,:).*0;
        psL=max(1,pIndex-250):min(length(sta(j).pre),1.5*sIndex-0.5*pIndex);
        try
          sta(j).pre(psL)=sta(j).pre(psL)*0-10;
        end
     end
     quake0(qCount).PS=[loc(:,i);double(ml/max(1,mCount))];
     fprintf('find a quake: %s la: %.2f lo: %.2f dep: %.2f Ml: %.2f res: %.2f no: %2d\n',datestr(quake0(qCount).PS(1)),quake0(qCount).PS(2:5),res(i),...
     sum(sign(quake0(qCount).pTime)));
end
if doAgain==0 && length(quake)~=0; if qCount~=0;quake=quake0;end;return;end
if qCount==0 || length(quake)==0;quake=[];return;end

quake1=detQuake(sta,modPhase,modP,doAgain-1);
if length(quake1)~=0;quake=[quake0,quake1];else quake=quake0;return;end
return
