dayPhase0=readPhaseLst('/home/jiangyr/jSvm/phaseLst0',datenum(2008,07,01));
clear dayPhaseVector
for i=[183:213]-183+1
    [dayPhaseVector(i).phaseVector,dayPhaseVector(i).phaseType]=...
    getVector(dayPhase0(i),i+183-1);
    fprintf('\n find vector :%d\n',size(dayPhaseVector(i).phaseType,1));
end

phaseCount=0;
phaseVector=[];phaseType=[];
for i=[183:213]-183+1
    if i<3;continue;end
    phaseVector=[phaseVector,dayPhaseVector(i).phaseVector];
    phaseType=[phaseType;dayPhaseVector(i).phaseType];
end

sacDelta=0.02;
kernelModel='poly';
gam=20;
sig2=[0.2,3,5];
af=100;
be=-100;
delta=sacDelta;
L=[12000:18600]';
BHCount=0;
BHY=[];BHX=[];
for i=1:length(BHDATA.y)
    if BHDATA.y(i)==-1;
       BHCount=BHCount+1;
       BHX(:,BHCount)=BHDATA.x(:,i);
       BHY(BHCount,1)=BHDATA.y(i);
    end
    if BHCount==400;break;end
end
LB1=[1:ceil(length(BHY)*0.9)]';
LB2=[ceil(length(BHY)*0.9):length(BHY)]';
[a,b,report,x,y]=calW6([BHX(:,LB1),phaseVector(:,L),BHX(:,LB2)],[BHY(LB1);sign(phaseType(L,1));BHY(LB2)],kernelModel,gam,sig2);
machineIsPhase.x=x;
machineIsPhase.y=y;
machineIsPhase.a=a;
machineIsPhase.b=b;
