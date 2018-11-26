setPath;
noise=zeros(382,0);
for i=1:length(sta)
    if sta(i).isF==0;continue;end
    L=10000+ceil(rand(80,1)*0.8*length(sta(i).data));
   noise(:,end+(1:length(L)))=conX(L,sta(i).data);
end
%load SC
inL=6200;
xTrain=zeros(382,inL);
yTrain=zeros(inL,1);
SC.XTSC=phaseVector;
SC.YSC=phaseType(:,1);
count=0;
for i=ceil(rand(1,length(SC.XTSC))*(length(SC.XTSC)-50)+1)
    if length(find(SC.XTSC(:,i)==0))>0;continue;end
    if length(find(isnan(SC.XTSC(:,i))~=0))>0;continue;end
    if rand<0.15
       ii=mod(i,size(noise,2))+1;
       if length(find(noise(:,ii)==0))>0;continue;end
       if length(find(isnan(noise(:,ii))~=0))>0;continue;end
       count=count+1;
       xTrain(:,count)=noise(:,ii); 
       yTrain(count)=-1;
           if count==inL;break;end
        continue;
    end
    count=count+1;
    xTrain(:,count)=SC.XTSC(:,i);
    yTrain(count)=sign(SC.YSC(i));
    if count==inL;break;end
end
kernelModel='poly';
gam=20;
sig2=[0.2,3,5];
[a,b,report,x,y]=calW5(xTrain,yTrain,kernelModel,gam,sig2);
machineIsPhase.x=x;
machineIsPhase.y=y;
machineIsPhase.a=a;
machineIsPhase.b=b;
