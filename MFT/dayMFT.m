%function [ waveformDet]= dayMFT(dayNum,waveform)
mode='butter1';
minSta=5;
setPara;
setPath;
loadFile;
delta=0.01;
dayLength=87000/delta;
L=[-2:delta:4]/delta;
winLen=floor(0.2/delta);
minCC=0.2;
minD=20/delta;
sDay0=dayNum;
maxN=20;



%% get  stations' waveform
filename=sprintf('%ssta_%dV3_100.mat',matDir,sDay0);
if exist(filename,'file')
%    load(filename);
else
    for i=1:length(staLst)
        sta(i).isF=0;sta(i).data=zeros(0,0,'single');sta(i).bSec=0;sta(i).delta=delta;sta(i).bNum=0;
        sta(i).peak=[];sta(i).xd=[];sta(i).A=[];sta(i).slrDataZ=[];sta(i).pre=single([]);
        sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
    end
end

perCount=0;proL=0;clock0=clock();
%f=[fl,fh];
for i=1:0%length(staLst)
    if exist(filename,'file')==0
        [sacEFile,sacNFile,sacZFile]=sacFileName(staLst(i).net,staLst(i).station,staLst(i).comp,sDay0);
        sta(i).isF=0;
        [sta(i).data,sta(i).bSec,sta(i).delta,~,sta(i).bNum,~,sta(i).isF]=mergeSac2data(sacEFile,sacNFile,sacZFile);
    end
    [proL,clock0]=processDis('filt staWave',i/length(staLst),'|',50,'*',datestr(dayNum,31),proL,clock0);
    if length(sta(i).data)<=20000;sta(i).isF=0;end
    if sta(i).isF==0;continue;end
    if 1%doFilt>0
        for j=1:3
            sta(i).data(:,j)=single(filter_fcn( double( sta(i).data(:,j)),sta(i).delta,mode,order,f,nodelay ));
        end
    end
    sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
    perCount=perCount+1;
end
%if perCount<3;waveformDet=[];return;end

count=0;
staMat=zeros(dayLength,maxN*2,'single');
addMat=zeros(87000/delta,1,'single');

for i=1:length(waveform)
    tmpSTime=clock;
    %% get the vail stations and their phases
    oTime=waveform(i).PS(1);
    for j=1:length(staLst)
            waveform(i).sTime(j)=sign(waveform(i).pTime(j))*waveform(i).sTime(j);
        if sta(j).isF==0||waveform(i).sta(j).isF==0
            waveform(i).pTime(j)=0;
            waveform(i).sTime(j)=0;
        end
    end
    [m,n]=size(waveform(i).pTime);
    if n>m
        waveform(i).pTime=waveform(i).pTime';
        waveform(i).sTime=waveform(i).sTime';
    end
    pL=find(waveform(i).pTime~=0);
    sL=find(waveform(i).sTime~=0);
    [~,pSort]=sort(waveform(i).pTime(pL));
    pL=pL(pSort(1:min(maxN,end)));
    [~,sSort]=sort(waveform(i).sTime(sL));
    sL=sL(sSort(1:min(maxN,end)));
    staL=[pL;sL];
    typeL=[pL*0+1;sL*0+2];
    if length(staL)<minSta
        continue;
    end
    staMat=staMat*0;
    proL=0;
    
     st=clock;
    
    %% cal cross correlation
    for j=length(staL):-1:1
        
        try
            if typeL(j)==1
                index=floor((waveform(i).pTime(staL(j))-waveform(i).oTime)*86400/delta);
                dTime(j)=(waveform(i).pTime(staL(j))-oTime);
                tmpWave=waveform(i).sta(staL(j)).waveform(index+L,3);
                try
                  tmpCC=jmxcorrnCudaff( sta(staL(j)).data(:,3),tmpWave);
                catch
                  fprintf('cuda xcorr fail');
                end
                ccLen=length(tmpCC);
                if ccLen==0;continue;end
                bTime=sta(staL(j)).bNum-dTime(j);
                bIndex=floor((bTime-dayNum)*86400/delta);
                staMat(max(1,bIndex):(ccLen+bIndex-1),j)=tmpCC(max(1,-bIndex+2):end);
            else
                index=floor((waveform(i).sTime(staL(j))-waveform(i).oTime)*86400/delta);
                dTime(j)=(waveform(i).sTime(staL(j))-oTime);
                tmpWave=waveform(i).sta(staL(j)).waveform(index+L,1);
                try
                tmpCC1=jmxcorrnCudaff(sta(staL(j)).data(:,1),tmpWave);
                catch
                  fprintf('cuda xcorr fail');
                end
                tmpWave=waveform(i).sta(staL(j)).waveform(index+L,2);
                try
                tmpCC2=jmxcorrnCudaff( sta(staL(j)).data(:,2),tmpWave);
                catch
                  fprintf('cuda xcorr fail');
                end
                tmpCC=max(tmpCC1,tmpCC2);
                ccLen=length(tmpCC);
                if ccLen==0;continue;end
                bTime=sta(staL(j)).bNum-dTime(j);
                bIndex=   floor((bTime-dayNum)*86400/delta);
                staMat(max(1,bIndex):(ccLen+bIndex-1),j)=tmpCC(max(1,-bIndex+2):end);
            end
            et=clock;
            dt=etime(et,st);
            perdt=dt/sum(typeL(j:end));
            [proL,clock0]=processDis(sprintf('cal corr: %3d | %.4f s perSta |',i,perdt),1-(j-1)/length(staL),'|',50,'*',datestr(dayNum,31),proL,clock0);
        catch
             fprintf('failed cal corr %d %d',i ,j);
        end
    end
    
    %% stack the correlation
    addMat=addMat*0;
    proL=0;minCount=0;
    for j=1:length(staL)
        
        tmp=cmaxCuda(staMat(:,j),87000/delta,winLen);
        tmp(isnan(tmp)==1)=0;
        if mean(tmp)<0.04;minCount=minCount+1;continue;end
        addMat(1:end-winLen+1)=addMat(1:end-winLen+1)+tmp;
        %     addMat(tmp>minCC)=addMat(tmp>minCC)+1;
        [proL,clock0]=processDis(sprintf('add corr: %3d',i),j/length(staL)-0.01,'|',50,'*',datestr(dayNum,31),proL,clock0);
    end
    if length(staL)-minCount<minSta;continue;end
    addMat=addMat/max(1,length(staL)-minCount);
    addStd=std(addMat);
    addMean=mean(addMat); 
    %% detect microearthquake according to the stacked results
    for mul=1:6
        minCC0=addMean+mul*addStd;
        [detCC,detL]=getdetec(addMat,minCC0,minD);
        detCount(mul)=length(find(detL~=-1));
    end
    minCC=addMean+5.5*addStd;
    minCC=min(0.3,max(0.25,minCC));
    [detCC,detL]=getdetec(addMat,minCC,minD);
    tmpDTime=etime(clock,tmpSTime);
    [~,clock0]=processDis(sprintf('add corr: %3d use: %.1fs find %2d mean:%.3f std:%.3f minCount: %d staL:%d %s',i,tmpDTime,length(find(detCC~=-1)),mean(addMat),std(addMat),minCount,length(staL),num2str(detCount)),j/length(staL),'|',10,'*',datestr(dayNum,31),proL,clock0);
    if isempty(detL);continue;end
    if detL(1)==-1;continue;end
    
    %% get the arrival time on each station and the orign time
    for j=1:length(detL)
        count=count+1;
        waveformDet(count).tmpIndex=i;
        waveformDet(count).name=datestr(waveform(i).PS(1),31);
        waveformDet(count).CC=detCC(j);
        waveformDet(count).mean=addMean;
        waveformDet(count).std=addStd;
        waveformDet(count).mul=(detCC(j)-addMean)/addStd;
        waveformDet(count).pCC=zeros(length(staLst),1);
        waveformDet(count).sCC=zeros(length(staLst),1);
        waveformDet(count).PS=zeros(5,1);
        waveformDet(count).pTime=zeros(length(staLst),1);
        waveformDet(count).sTime=zeros(length(staLst),1);
        waveformDet(count).PS(1)=dayNum+detL(j)*delta/86400+(-L(1)+4)*delta/86400;
        waveformDet(count).PS(2:4)=waveform(i).PS(2:4);
        waveformDet(count).pD=zeros(length(staLst),1);
        waveformDet(count).sD=zeros(length(staLst),1); %#ok<*AGROW>
        waveformDet(count).tmpIndex=i;
        waveformDet(count).tmpTime=waveform(i).PS(1);
        pCount=0;dIndex=[];
        for k=1:length(staL)
            pCount=pCount+1;
            tmp=staMat(max(1,min(dayLength,(detL(j)+[1:winLen]-1))),k); %#ok<*NBRAK>
            [tmpCC,maxIndex]=max(tmp);
            dIndex(pCount)=maxIndex-1;
            index=maxIndex-1+detL(j);
            if typeL(k)==1
                waveformDet(count).pTime(staL(k),1)=dayNum+dTime(k)+index*delta/86400+(-L(1)+4)*delta/86400;
                waveformDet(count).pCC(staL(k),1)=tmpCC;
                waveformDet(count).pD(staL(k),1)=(maxIndex-1)*delta/86400;
            else
                waveformDet(count).sTime(staL(k),1)=dayNum+index*delta/86400+dTime(k)+(-L(1)+4)*delta/86400;
                waveformDet(count).sCC(staL(k),1)=tmpCC;
                waveformDet(count).sD(staL(k),1)=(maxIndex-1)*delta/86400;
            end
        end
        waveformDet(count).PS(1)=dayNum+detL(j)*delta/86400+(-L(1)+4)*delta/86400+mean(dIndex)*delta/86400;
        waveformDet(count).pD(waveformDet(count).pTime~=0)= waveformDet(count).pD(waveformDet(count).pTime~=0)-mean(dIndex)*delta/86400;
        waveformDet(count).sD(waveformDet(count).sTime~=0)= waveformDet(count).sD(waveformDet(count).sTime~=0)-mean(dIndex)*delta/86400;
        waveformDet(count).oTime= waveformDet(count).PS(1)-100/86400;
        waveformDet(count).eTime= waveformDet(count).PS(1)+150/86400;
        %         oTime= waveformDet(count).PS(1)-100/86400;
        %         eTime= waveformDet(count).PS(1)+150/86400;
        %         for k=1:length(sta)
        %             waveformDet(count).sta(k).isF=0;
        %             if sta(k).isF==0|| waveformDet(count).pTime(k)==0;continue;end
        %             bIndex=floor((oTime-sta(k).bNum)*86400/delta);
        %             eIndex=floor((eTime-sta(k).bNum)*86400/delta);
        %             if  bIndex>0&& eIndex<=length(sta(k).data);
        %                 waveformDet(count).sta(k).isF=1;
        %                 waveformDet(count).sta(k).waveform=sta(k).data(bIndex:eIndex,:);
        %                 waveformDet(count).sta(k).delta=sta(k).delta;
        %             end
        %         end
    end
    
    
end
return
[loc,res]=locQuake(waveformDet,2);
for i=1:length(res)
    waveformDet(i).PS(1:4)=loc(:,i);
end
[timeL,indexL]=sort(loc(1,:));
L=[];mul=0;oTime=0;
for i=1:length(indexL)
    index=indexL(i);
    if timeL(i)==0;continue;end
    if timeL(i)-oTime>20/86400;
       L(end+1)=index;
       mul=waveformDet(index).mul;
       oTime=timeL(i);continue;end
    if waveformDet(index).mul>mul;
       L(end)=index;
       mul=waveformDet(index).mul;
       oTime=timeL(i);continue;end
end
for i=L
     ml=0;mCount=0;
      for j=1:length(waveformDet(i).pTime)

        if sta(j).isF==0;continue;end  
        if waveformDet(i).pTime(j)==0;continue;end  
         pIndex=ceil((waveformDet(i).pTime(j)-sta(j).bNum)*86400/delta+1);
         sIndex=max(ceil((waveformDet(i).sTime(j)-sta(j).bNum)*86400/delta+1),pIndex+250);
         dk=distaz(sta(j).la,sta(j).lo,loc(2,i),loc(3,i));
         dk=max(10,dk); 
         if sIndex-50>0 && sIndex+300<length(sta(j).data);sA=getSA(sta(j).data(sIndex+[-50:300],:))*delta;else sA=0;end
         if sA~=0 && dk >10 && dk <550;mCount=mCount+1;ml=ml+max(-1,log10(sA)+1.1*log10(dk)+0.00189*dk-2.09-0.23);end 
       end
       tmpIndex=waveformDet(i).tmpIndex;
       waveformDet(i).PS(5)=double(ml/max(1,mCount))-waveform(tmpIndex).dml;
end



%end
