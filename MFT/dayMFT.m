function [ waveformDet]= dayWaveform(dayNum,waveform)
%setPara;
mode='butter1';
minSta=5;
setPara;
setPath;
loadFile;
delta=0.01;
L=[-2:delta:2]/delta;
winLen=floor(0.2/delta);
minCC=0.2;
minD=20/delta;
sDay0=dayNum;
filename=sprintf('%ssta_%dV3_100.mat',matDir,sDay0);
maxN=20;
if exist(filename,'file')
   load(filename);
else
   for i=1:length(staLst)
       sta(i).isF=0;sta(i).data=zeros(0,0,'single');sta(i).bSec=0;sta(i).delta=delta;sta(i).bNum=0;
       sta(i).peak=[];sta(i).xd=[];sta(i).A=[];sta(i).slrDataZ=[];sta(i).pre=single([]);
       sta(i).name=staLst(i).name;sta(i).la=staLst(i).la;sta(i).lo=staLst(i).lo;
   end
end
perCount=0;
proL=0;
clock0=clock();
for i=1:length(staLst)
    if exist(filename,'file')==0
       [sacEFile,sacNFile,sacZFile]=sacFileName(staLst(i).net,staLst(i).station,staLst(i).comp,sDay0);
       sta(i).isF=0;
       [sta(i).data,sta(i).bSec,sta(i).delta,eSec,sta(i).bNum,eNum,sta(i).isF]=mergeSac2data(sacEFile,sacNFile,sacZFile);
    end
    [proL,clock0]=processDis('filt staWave',i/length(staLst),'|',100,'*',datestr(dayNum,31),proL,clock0);
    bNumM=mod(sta(i).bNum,1);bNumN=floor(sta(i).bNum);
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
if perCount<3;quake=[];waveformDet=[];return;end
for i=1:length(waveform)
	waveformDet(i).isF=0;
	oTime=waveform(i).PS(1);
	for j=1:length(staLst);
		if sta(j).isF==0||waveform(i).sta(j).isF==0;
			waveform(i).pTime(j)=0;
			waveform(i).sTime(j)=0;
		end
	end
%	pL=find(waveform(i).pTime~=0);
%	sL=find(waveform(i).sTime~=0);
        [m,n]=size(waveform(i).pTime);
        if n>m
          waveform(i).pTime=waveform(i).pTime';
          waveform(i).sTime=waveform(i).sTime';
         end
        pL=find(waveform(i).pTime~=0);
        sL=find(waveform(i).sTime~=0);
        [tmp,pSort]=sort(waveform(i).pTime(pL));
        pL=pL(pSort(1:min(maxN,end)));
        [tmp,sSort]=sort(waveform(i).sTime(sL));
        sL=sL(sSort(1:min(maxN,end)));
	staL=[pL;sL];
	typeL=[pL*0+1;sL*0+2];
	if length(staL)<minSta
		continue;
	end
	staMat=zeros(87000/delta,length(staL));
        proL=0;
	for j=1:length(staL)
            
        try
        if typeL(j)==1;
        	index=floor((waveform(i).pTime(staL(j))-waveform(i).oTime)*86400/delta);
                dTime(j)=(waveform(i).pTime(staL(j))-oTime);
%                waveform(i).sta(staL(j)).waveform(:,3)=single(filter_fcn( double(waveform(i).sta(staL(j)).waveform(:,3)),sta(staL(j)).delta,mode,order,f,nodelay ));
        	tmpWave=waveform(i).sta(staL(j)).waveform(index+L,3);
        	tmpCC=jmxcorrn( tmpWave,sta(staL(j)).data(:,3))';
        	ccLen=length(tmpCC);
                if ccLen==0;continue;end
        	bTime=sta(i).bNum-dTime(j);
        	bIndex=floor((bTime-dayNum)*86400/delta);
                staMat(max(1,bIndex):(ccLen+bIndex-1),j)=tmpCC(max(1,-bIndex+2):end);
        else
        	index=floor((waveform(i).sTime(staL(j))-waveform(i).oTime)*86400/delta);
                dTime(j)=(waveform(i).sTime(staL(j))-oTime);
%                waveform(i).sta(staL(j)).waveform(:,1)=single(filter_fcn( double(waveform(i).sta(staL(j)).waveform(:,1)),sta(staL(j)).delta,mode,order,f,nodelay ));
                tmpWave=waveform(i).sta(staL(j)).waveform(index+L,1);
        	tmpCC1=jmxcorrn( tmpWave,sta(staL(j)).data(:,1))';
%                waveform(i).sta(staL(j)).waveform(:,2)=single(filter_fcn( double(waveform(i).sta(staL(j)).waveform(:,2)),sta(staL(j)).delta,mode,order,f,nodelay ));
                 tmpWave=waveform(i).sta(staL(j)).waveform(index+L,2);
        	tmpCC2=jmxcorrn( tmpWave,sta(staL(j)).data(:,2))';
        	tmpCC=max(tmpCC1,tmpCC2);
        	ccLen=length(tmpCC);
                if ccLen==0;continue;end
        	bTime=sta(i).bNum-dTime(j);
                bIndex=   floor((bTime-dayNum)*86400/delta);
                staMat(max(1,bIndex):(ccLen+bIndex-1),j)=tmpCC(max(1,-bIndex+2):end);
        end

        [proL,clock0]=processDis(sprintf('cal corr: %3d',i),j/length(staL),'|',100,'*',datestr(dayNum,31),proL,clock0);
        end
    end
proL=0;
    addMat=zeros(87000/delta,1);
    for j=1:length(staL)

        tmp=cmax(staMat(:,j),87000/delta,winLen);
        tmp(find(isnan(tmp)==1))=0;
        addMat(1:end-winLen+1)=addMat(1:end-winLen+1)+tmp;
   %     addMat(tmp>minCC)=addMat(tmp>minCC)+1;
        [proL,clock0]=processDis(sprintf('add corr: %3d',i),j/length(staL)-0.01,'|',100,'*',datestr(dayNum,31),proL,clock0);
	end
	addMat=addMat/length(staL);
    [detCC,detL]=getdetec(addMat,minCC,minD);
[proL,clock0]=processDis(sprintf('add corr: %3d find %2d',i,length(detCC)),j/length(staL),'|',100,'*',datestr(dayNum,31),proL,clock0);
    if length(detL)==0;continue;end
    waveformDet(i).isF=1;count=0;
    for j=1:length(detL)
    	count=count+1;
        oTime=detL(j)*delta/86400+dayNum;
        waveformDet(i).quake(count).CC=detCC(j);
        waveformDet(i).quake(count).pCC=zeros(length(staLst),1);
        waveformDet(i).quake(count).sCC=zeros(length(staLst),1);
        waveformDet(i).quake(count).PS=zeros(5,1);
        waveformDet(i).quake(count).pTime=zeros(length(staLst),1);
        waveformDet(i).quake(count).sTime=zeros(length(staLst),1);
        waveformDet(i).quake(count).PS(1)=dayNum+detL(j)*delta/86400+(-L(1)+4)*delta/86400;
        waveformDet(i).quake(count).PS(2:4)=waveform(i).PS(2:4);
        waveformDet(i).quake(count).pD=zeros(length(staLst),1);
        waveformDet(i).quake(count).sD=zeros(length(staLst),1);
        waveformDet(i).quake(count).tmpIndex=i;
        waveformDet(i).quake(count).tmpTime=waveform(i).PS(1);
        pCount=0;dIndex=[]; 
        for k=1:length(staL)
                pCount=pCount+1;
                tmp=staMat(max(1,min(end,(detL(j)+[1:winLen]-1))),k);
        	[tmpCC,maxIndex]=max(tmp);
                dIndex(pCount)=maxIndex-1;
        	index=maxIndex-1+detL(j);
        	if typeL(k)==1
        	 waveformDet(i).quake(count).pTime(staL(k),1)=dayNum+dTime(k)+index*delta/86400+(-L(1)+4)*delta/86400;
        	 waveformDet(i).quake(count).pCC(staL(k),1)=tmpCC;
                 waveformDet(i).quake(count).pD(staL(k),1)=(maxIndex-1)*delta/86400;
        	else
             waveformDet(i).quake(count).sTime(staL(k),1)=dayNum+index*delta/86400+dTime(k)+(-L(1)+4)*delta/86400;
             waveformDet(i).quake(count).sCC(staL(k),1)=tmpCC;
             waveformDet(i).quake(count).pD(staL(k),1)=(maxIndex-1)*delta/86400;
            end
        end
        waveformDet(i).quake(count).PS(1)=dayNum+detL(j)*delta/86400+(-L(1)+4)*delta/86400+mean(dIndex)*delta/86400;
        waveformDet(i).quake(count).pD(waveformDet(i).quake(count).pTime~=0)= waveformDet(i).quake(count).pD(waveformDet(i).quake(count).pTime~=0)-mean(dIndex)*delta/86400;
        waveformDet(i).quake(count).sD(waveformDet(i).quake(count).sTime~=0)= waveformDet(i).quake(count).pD(waveformDet(i).quake(count).sTime~=0)-mean(dIndex)*delta/86400;
         waveformDet(i).quake(count).oTime= waveformDet(i).quake(count).PS(1)-100/86400;
         waveformDet(i).quake(count).eTime= waveformDet(i).quake(count).PS(1)+150/86400;
    oTime= waveformDet(i).quake(count).PS(1)-100/86400;
    eTime= waveformDet(i).quake(count).PS(1)+150/86400;
   % for k=1:length(sta)
      %  waveformDet(i).quake(count).sta(k).isF=0;
      %  if sta(k).isF==0|| waveformDet(i).quake(count).pTime(k)==0;continue;end
      %  bIndex=floor((oTime-sta(k).bNum)*86400/delta);
      %  eIndex=floor((eTime-sta(k).bNum)*86400/delta);
      %  if  bIndex>0&& eIndex<=length(sta(k).data);
      %       waveformDet(i).quake(count).sta(k).isF=1;
      %        waveformDet(i).quake(count).sta(k).waveform=sta(k).data(bIndex:eIndex,:);
      %        waveformDet(i).quake(count).sta(k).delta=sta(k).delta;
      % end
    % end
    end

end

end
