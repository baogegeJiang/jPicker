%dayPhase0=readPhaseLst('/home/jiangyr/jSvm/phaseLst0',datenum(2008,07,01));
%day=readQuakeLst('/home/jiangyr/jSvm/phaseLst0',datenum(2008,07,01),dayPhase0);
clear dayPhaseXDVector
for i=[183:186]-183+1
    [dayPhaseXDVector(i).phaseXDVector,dayPhaseXDVector(i).phaseXDType]=...
    getXDVector(day(i),i+183-1);
    fprintf('\n find vector :%d\n',size(dayPhaseXDVector(i).phaseXDType,1));
end

phaseCount=0;
phaseXDVector=[];phaseXDType=[];
for i=[183:186]-183+1
    %if i<3;continue;end
    phaseXDVector=[phaseXDVector,dayPhaseXDVector(i).phaseXDVector];
    phaseXDType=[phaseXDType;dayPhaseXDVector(i).phaseXDType];
end

sacDelta=0.02;
kernelModel='poly';
gam=20;
sig2=[0.2,3,5];
af=100;
be=-100;
delta=sacDelta;
L=[1:5000]';

[ad,bd,report,xd,yd]=calW6(phaseXDVector(:,L),sign(phaseXDType(L,1)),kernelModel,gam,sig2);
machineIsP.x=xd;
machineIsP.y=yd;
machineIsP.a=ad;
machineIsP.b=bd;
