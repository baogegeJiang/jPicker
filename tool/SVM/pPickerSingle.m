function[pIndex,sIndex]=pPickerSingle(pIndex0,sIndex0,data,toDoLst,modPhase,modP)

jL=[-150:150];jLS1=[-250:250];jLS2=[-250:250];jLS=[-250:250]; 
isStrict=0;
setPicker;
jLS=jLS1;
minPrePS=0.06;
delta=0.02;
pIndex=0;sIndex=0;minD=50;minDS=25;arN=3;
isPhaseA=[-0:0];
FL=[-2:2];
PSL=50;%0.25
minSvmIsP=0;
if pIndex0*sIndex0==0
   return
   pIndex0=200;sIndex0=200;
   jL=0:length(data)-pIndex0-200;jLS1=jL;jLS2=jL;jLS=jL; 
 end
%if (sIndex-pIndex)*delta<10/86400;jLS=jLS1;else;jLS=jLS2;end
if length(data)<50;return ;end
pIndex0=floor(pIndex0);sIndex0=floor(sIndex0);

%% SVM pick P
if toDoLst(1)>0
    if pIndex0-2000<1||pIndex0+500>length(data(:,1));return;end
    vectorLst=pIndex0+jL;
    if length(vectorLst)>0
        [xt]=conX(vectorLst,data);
        [isPhase,m]=preT(xt,modPhase);
    end
    minIsPhase=0; 
   [jValue,jLst]=getdetec(isPhase,minIsPhase,minD);
   if jLst(1)>0;
      pIndex=pIndex0+jL(1)+jLst(1)-1;
   else
      pIndex=0;sIndex=0;
       return;
   end
   if  length(find(data(pIndex+[-6:-1],:)==0))>1;pIndex=0;sIndex=0;return;end
end
pIndex0=pIndex;
%% AR-AIC pick P
if toDoLst(2)==1  
   be1=150;af1=100;be2=50;af2=200;
   if pIndex0-be1>0 && pIndex0+af1<length(data)
      [maxV,arDataT]=ArAic2(data(pIndex0-be1:pIndex0+af1,3),arN,be2,af2);
      [aMax,pIndexTemp]=max(arDataT(be2:af2));
      if pIndexTemp>10&&pIndexTemp<af2-be2-10
      pIndex=pIndexTemp+be2-1-be1+pIndex0-1+(arN+1)/2-6;
      end
    end
end
if  length(find(data(pIndex+[-6:-1],:)==0))>1;pIndex=0;sIndex=0;return;end
pA=max(max(data(pIndex+[-200:250],:)));
if isStrict==1 && max(max(data(pIndex+[-1000:-250],:)))*2>pA;pIndex=0;sIndex=0;return;end
pIndex0=pIndex;

%% SVM pick S
isS=0;
pXD=conXD(pIndex0,data);
midIndex=(pIndex0+sIndex0)/2;
if toDoLst(3)>0;
    if toDoLst(3)==3;
       jLS=[-200:200];
end
    if sIndex0-1000<1||sIndex0+800>length(data(:,1));return;end
    vectorLst=jLS+sIndex0;
    if length(vectorLst)>0
        [xt]=conX(vectorLst,data);
        [isPhase,m]=preT(xt,modPhase);
    end
   [jValue,jLst]=getdetec(isPhase,0,minDS);
    xtd=conXD(sIndex0+jLS,data);
   isS=0;
   if jLst(1)>0;
      for k=1:length(jLst)
          if size(pXD,1)~=size(xtd,1)
             continue;
          end 
          [isP,m]=preT([pXD;xtd(:,jLst(k))],modP);
          if sIndex0+jLS(jLst(k))<pIndex0+50;continue;end

          if isP<minSvmIsP;sIndex=sIndex0+jLS(jLst(k));isS=1;
          break;end
      end
   end
   if isS==0 || pIndex>sIndex
      sIndex=0;return;   
   end
end


%% calculate other things to aviod wrong pick
%pA=max(max(sta.data(pIndex+[-200:200],:)));                                               
sA=max(max(data(mod(sIndex+[-300:500]-1,length(data))+1,:)));                                               
if sA<0.3*pA && (sIndex-pIndex)/50>15;sIndex=0;
return;end   
if pIndex>50 && sIndex>50&& pIndex+50<length(data)&& sIndex+50<length(data)                                       
if  length(find(data(pIndex+[-50:50],:)==0))>3;pIndex=0;sIndex=0;return;end
if  length(find(data(sIndex+[-50:50],:)==0))>3;sIndex=0;return;end
end
