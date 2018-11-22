function[peak,xd,A,slrZ,pre]=pickPeak(data,modPhase,pre) 
%% to get the alternative arrival time and their amplitude and XD
A=0;

sacPreCount=min(20000,ceil(size(data,1)/2));
minD=30;minSLR=3;minSVMd=0;minSVMP1=0;minSVMP2=0;
setPara;
jL=-200:200;
jL2=-1000:2500;
svmL=[0];
peakCount=0;
peak=[];
nextIndex=0;
dataLength=length(data);
data0=data;
data=[data(sacPreCount:-1:1,:);data;data(dataLength:-1:dataLength-sacPreCount+1,:)];
slrDataE=SLR(data(:,1));
slrDataN=SLR(data(:,2));
slrDataZ=SLR(data(:,3));
slrData=max([slrDataE;slrDataN;slrDataZ]);
slrZ=slrData(sacPreCount+[1:length(data0)]);
if length(pre)==0
pre=(slrData*0-99999)';
else
pre=[(zeros(sacPreCount,1)-99999);pre;(zeros(sacPreCount+1,1)-99999)];
end
[slrPeak,slrLst]=getdetec2(slrData([1:dataLength]+sacPreCount),minSLR,30);

for i=1:length(slrLst)

    pIndex=slrLst(i)+sacPreCount;
    vectorLst=find(pre(pIndex+jL)==-99999)+pIndex+jL(1)-1;    
    if length(vectorLst)>0
        [xt]=conX(vectorLst,data);
        [isPhase,m]=preT(xt,modPhase);
        pre(vectorLst,1)=isPhase;
    end
    [jValue,jLst]=getdetec(pre(pIndex+jL),minSVMd,minD);

    isPfind=0;
    if jLst(1)<=0; continue;end 
    for j=jLst  
        if mean((pre(pIndex+j-1+jL(1)+svmL)))>minSVMP1  
            pIndex=pIndex+j-1+jL(1);isPfind=1;  
            break; 
        end  
    end 
    if isPfind==0;continue;end
    vectorLst=find(pre(pIndex+jL2)==-99999)+pIndex+jL2(1)-1;
    if length(vectorLst)>0
        [xt]=conX(vectorLst,data);
        [isPhase,m]=preT(xt,modPhase);
        pre(vectorLst,1)=isPhase;
    end
end
[jValue,jLst]=getdetec(pre(1+sacPreCount:end-sacPreCount-1),minSVMd,minD);
peak=[jLst-1+1+sacPreCount];peakCount=length(jLst);
xd=conXD(peak,data);
for i=1:length(peak)
    sIndex=max(peak(i)-50,1);eIndex=min(peak(i)+500,length(data));
    A(i,1)=max(data(sIndex:eIndex,1).^2+data(sIndex:eIndex,2).^2+data(sIndex:eIndex,3).^2)^0.5;
end
peak=peak-sacPreCount;
pre=pre(1+sacPreCount:end-sacPreCount-1);
