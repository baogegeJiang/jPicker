function[peak,xd,A,slrZ,pre]=pickPeakAll(data,modPhase,pre)
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
if isempty(pre)
    pre=(slrData*0-99999)';
else
    pre=[(zeros(sacPreCount,1)-99999);pre;(zeros(sacPreCount+1,1)-99999)];
end
[~,slrLst]=getdetec2(slrData([1:dataLength]+sacPreCount),minSLR,30);

mul1=1;mul=1;
windowLength=75;windowLengthX=windowLength*2+1;
windowLengthL1=[1:windowLengthX-3,windowLengthX+(1:windowLengthX-3)];
windowLengthL2=windowLengthL1+3;
% plot(windowLengthL2);
% return
i1=single([1:40].^2*5+windowLength);
i2=single([0:39].^2*5+windowLength);
x=zeros(382,1,'single');
lN=3000;
xt=zeros(382,lN,'single');

i12=i1;i21=i1;
for i=1:length(i1)
    tmp=-i1(i):3:-i2(i)-1;
    i12(i)=-tmp(end);
    tmp=i2(i):3:i1(i)-1;
    i21(i)=tmp(end);
end
count=0;i0=1;
if sum(pre==-99999)/length(pre)>0.9
    for k=mod(ceil(rand*1000),3)+1
        i0=-100000;
        x=single(conXO(sacPreCount+k,data));
        L=(sacPreCount+k):3:(sacPreCount+dataLength);
        modIndex=mod(L(1),3);
        for i=(sacPreCount+k):3:(sacPreCount+dataLength)
            if i>i0+5000 && mod(i,3)==modIndex
                x=single(conXO(i,data));
                i0=i;
            else
                x10=data(i+windowLength+[-2:0],1);
                x110=data(i+windowLength+[-2:0],2);
                x111=(x10.^2+x110.^2).^(1/2)/mul1;
                x(windowLengthL1)=x(windowLengthL2);
                x(windowLength*2+1+(-2:0))=x111;
                x(windowLengthL1(end)+(1:3))=data(i+windowLength+(-2:0),3);
                if mod(i,3)==modIndex
                    for j=1:length(i1)
                        x(windowLengthL2(end)+j,1)=abs(...
                            x(windowLengthL2(end)+j,1)^2+(-sum(data(i-i1(j)-3+1,:).^2)+ ...
                            sum(data(i-i12(j)+1,:).^2))/((i1(j)-i2(j)+1)*mul^2) ...
                            ).^0.5;
                        x(windowLengthL2(end)+length(i1)+j,1)=abs(...
                            x(windowLengthL2(end)+length(i1)+j,1)^2+(-sum(data(i+i2(j)-3+1,:).^2)+ ...
                            sum(data(i+i21(j)+1,:).^2))/((i1(j)-i2(j)+1)*mul^2) ...
                            ).^0.5;
                    end
                end
                
            end
            if sum(imag(x)~=0)>0
                i-sacPreCount
                max(abs(imag(x)))
                pause(1)
            end
            count=count+1;
            xt(:,count)=x/norm(abs(x(1:302)));
            indexL(count)=i;
            if count==lN || count==L(end)
                %                 fprintf('%.5f\n',i/length(data));
                [isPhase,~]=preT(xt(:,1:count),modPhase);
                pre(indexL(1:count),1)=isPhase;
                count=0;
            end
        end
    end
end

[~,jLst]=getdetec(pre(1+sacPreCount:end-sacPreCount-1),minSVMd,minD);
peak=[jLst-1+1+sacPreCount];%peakCount=length(jLst);
xd=conXD(peak,data);
for i=1:length(peak)
    sIndex=max(peak(i)-50,1);eIndex=min(peak(i)+500,length(data));
    A(i,1)=max(data(sIndex:eIndex,1).^2+data(sIndex:eIndex,2).^2+data(sIndex:eIndex,3).^2)^0.5;
end
peak=peak-sacPreCount;
pre=pre(1+sacPreCount:end-sacPreCount-1);
