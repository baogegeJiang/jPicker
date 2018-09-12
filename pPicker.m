function[pTime,sTime,pre]=pPicker(pIndex,sIndex,sta,toDoLst,modPhase,modP)
%% initialize
pre=0;
pIndexO=pIndex;
try
pre=sta.pre;
end
if length(pre)<50;pre=sta.data(:,1)*0-99999;fprintf('wrong pre \n');end
try
jL=[-150:150];jL1=[-150:150];jLS1=[-250:250];jLS2=[-250:250];jLS=[-250:250]; 
isStrict=0;
setPicker;
oIndex=ceil(calOTime(pIndex,sIndex));
dIndex=sIndex-pIndex;
jLS=jLS1;
minPrePS=0.06;
delta=0.02;
pTime=0;sTime=0;minD=50;minDS=25;arN=3;
isPhaseA=[-0:0];
FL=[-2:2];
PSL=50;%0.25
minSvmIsP=0;
if (sIndex-pIndex)*delta>30;jL=jL1;jLS=jLS1;end
if length(sta.data)<50;return ;end
if length(pre)<50;return ;end
isRe=0;
if toDoLst(1)==3&& isStrict>0
   isStrict=0;
end
if toDoLst(1)==4&& isStrict>0
   isStrict=1;
end
pIndex=floor(pIndex);sIndex=floor(sIndex);

%% SVM pick P
if toDoLst(1)>0
    if pIndex+jL(1)<1||pIndex+jL(end)>length(sta.data(:,1));return;end
    vectorLst=find(pre(pIndex+jL)==-99999)+pIndex+jL(1)-1;
    if length(vectorLst)>0
        [xt]=conX(vectorLst,sta.data);
        [isPhase,m]=preT(xt,modPhase);
        pre(vectorLst,1)=isPhase;
    end
    isPhase=pre(pIndex+jL);
    minIsPhase=0; 
   [jValue,jLst]=getdetec(isPhase,minIsPhase,minD);
   if jLst(1)>0;
      pIndex=pIndex+jL(1)+jLst(1)-1;
      if jLst(1)>50 && length(isPhase)-jLst(1)>50
         isRe=1;
      end
   else
      pTime=0;sTime=0;
       return;
   end
   if  length(find(sta.data(pIndex+[-6:-1],:)==0))>1;pTime=0;sTime=0;return;end
end
pTime=(pIndex-1)*delta/(3600*24)+sta.bNum;

%% AR-AIC pick P
if toDoLst(2)==1  
   pIndexO=pIndex;
   if pre(pIndex)-floor(pre(pIndex))==0.1234567
      pIndex=floor(pre(pIndex))-100000;
   else
      be1=150;af1=100;be2=50;af2=200;
      if pIndex-be1>0 && pIndex+af1<length(sta.data)
         [maxV,arDataT]=ArAic2(sta.data(pIndex-be1:pIndex+af1,3),arN,be2,af2);
         [aMax,pIndexTemp]=max(arDataT(be2:af2));
         if pIndexTemp>10&&pIndexTemp<af2-be2-10
            pIndex=pIndexTemp+be2-1-be1+pIndex-1+(arN+1)/2-6;
         end
      end
      if isRe==1
         pre(pIndexO)=max(pre(pIndexO),100000+pIndex+0.1234567);
       end
   end
end
pTime=(pIndex-1)*delta/(3600*24)+sta.bNum;
if  length(find(sta.data(pIndex+[-6:-1],:)==0))>1;pTime=0;sTime=0;return;end
pA=max(max(sta.data(pIndex+[-200:200],:)));
pATmp=max(max(sta.data(pIndex+[-200:250],:)));
if isStrict==1 && max(max(sta.data(mod(pIndex+[-1000:-250]-1,length(sta.data))+1,:)))*2.5>pATmp;pTime=0;sTime=0;return;end
if toDoLst(1)==3 && max(max(sta.data(mod(pIndex+[-1000:-250]-1,length(sta.data))+1,:)))*2.5>pATmp&&abs(pIndex-pIndexO)>50;pTime=0;sTime=0;return;end

%% SVM pick S
isS=0;
pXD=conXD(pIndex,sta.data);
midIndex=(pIndex+sIndex)/2;
if toDoLst(3)>0;
    if sIndex+jLS(1)<1||sIndex+jLS(end)>length(sta.data(:,1));return;end
    vectorLst=find(pre(sIndex+jLS)==-99999)+sIndex+jLS(1)-1;
    if length(vectorLst)>0
        [xt]=conX(vectorLst,sta.data);
        [isPhase,m]=preT(xt,modPhase);
        pre(vectorLst,1)=isPhase;
    end
    isPhase=pre(sIndex+jLS);
   [jValue,jLst]=getdetec(isPhase,0,minDS);
    xtd=conXD(sIndex+jLS,sta.data);
   isS=0;
   if jLst(1)>0;
      for k=1:length(jLst)
          if size(pXD,1)~=size(xtd,1)
             continue;
          end 
          [isP,m]=preT([pXD;xtd(:,jLst(k))],modP);
          if sIndex+jLS(jLst(k))<pIndex+50 ||  sIndex+jLS(jLst(k))<midIndex;continue;end
          if isP<minSvmIsP;sIndex=sIndex+jLS(jLst(k));isS=1;
          break;end
      end
   end
   if isS==0 || pIndex>sIndex
      sTime=0;return;
      else
      sTime=(sIndex-1)*delta/(3600*24)+sta.bNum;   
   end
end
if isStrict==2 && max(max(sta.data(mod(pIndex+[-1000:-250]-1,length(sta.data))+1,:)))*2.5>pATmp&&(sTime==0||abs(pIndex-pIndexO)>50);pTime=0;sTime=0;return;end
%% calculate other things to aviod wrong pick
%pA=max(max(sta.data(pIndex+[-200:200],:)));                                               
sA=max(max(sta.data(mod(sIndex+[-300:600]-1,length(sta.data))+1,:)));                                               
if sA<0.3*pA && (sIndex-pIndex)/50>15;sTime=0;
return;end   
if pIndex>50 && sIndex>50&& pIndex+50<length(sta.data)&& sIndex+50<length(sta.data)                                       
if  length(find(sta.data(pIndex+[-50:50],:)==0))>3;pTime=0;sTime=0;return;end
if  length(find(sta.data(sIndex+[-50:50],:)==0))>3;sTime=0;return;end
end
sTime=(sIndex-1)*delta/(3600*24)+sta.bNum;
catch
pTime=0;sTime=0;
end
if toDoLst(3)==2&&sTime==0&&abs(pIndex-pIndexO)>50;pTime=0;end
