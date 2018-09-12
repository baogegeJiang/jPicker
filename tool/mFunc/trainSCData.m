sacDelta=0.02;
kernelModel='poly';
gam=20;
sig2=[0.2,3,5];
L=[1:6000];
[machineIsPhase.a,machineIsPhase.b,report,machineIsPhase.x,machineIsPhase.y]=calW5([nX(:,1:720),SC.XTSC(:,L),nX(:,721:800)],[nY(1:720,1);SC.YSC(L);nY(721:800,1);],kernelModel,gam,sig2); 
