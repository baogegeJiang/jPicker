clear compXD eqInfor 
pPhase={'p','P','Pn','pP','Sp','sP','PP','SP'};
sPhase={'s','S','sS','SS','Sn','pS','PS'};
eqInfor=[];
for i=2:length(eqXD)
TP=eqXD(i).p0Vector;
resTP=calXD(TP);
pL=[];sL=[];pVecCos=[];sVecCos=[];pPhaCos=[];sPhaCos=[];
pCount=0;sCount=0;
PPhase=[];SPhase=[];%eqInfor=[];
for j=2:eqXD(i).phaseCount
if ismember(eqXD(i).phaseName{j},pPhase)
pCount=pCount+1;
pL(:,pCount)=eqXD(i).TP(:,j);
PPhase(pCount,1).phaseName=eqXD(i).phaseName{j};
PPhase(pCount,1).phaseTime=eqXD(i).phaseTime(j);
PPhase(pCount,1).phaseTP=eqXD(i).TP(:,j);
PPhase(pCount,1).phaseDete=eqXD(i).phaseDete(j);
tempTP=[TP;eqXD(i).TP(:,j)];
PPhase(pCount,1).phaseDist=preT(tempTP,machineIsP);
continue
end
if ismember(eqXD(i).phaseName{j},sPhase)
sCount=sCount+1;
sL(:,sCount)=eqXD(i).TP(:,j);
SPhase(sCount,1).phaseName=eqXD(i).phaseName{j};
SPhase(sCount,1).phaseTime=eqXD(i).phaseTime(j);
SPhase(sCount,1).phaseTP=eqXD(i).TP(:,j);
SPhase(sCount,1).phaseDete=eqXD(i).phaseDete(j);
tempTP=[TP;eqXD(i).TP(:,j)];
SPhase(sCount,1).phaseDist=preT(tempTP,machineIsP);
continue
end
end
if pCount*sCount==0;
continue
end
i
for j=1:pCount
temp=calXD(pL(:,j));
pVecCos(j)=temp.vec'*resTP.vec;
pPhaCos(j)=temp.phase'*resTP.phase;
pF1(j)=acos(abs(pVecCos(j)))/(pi/2);
pF2(j)=temp.F2;
pF3(j)=1-resTP.vec'*temp.S*resTP.vec;
end
for j=1:sCount
temp=calXD(sL(:,j));
sVecCos(j)=temp.vec'*resTP.vec;
sPhaCos(j)=temp.phase'*resTP.phase;
sF1(j)=acos(abs(sVecCos(j)))/(pi/2);
sF2(j)=temp.F2;
sF3(j)=1-resTP.vec'*temp.S*resTP.vec;
end
eqInfor(i).pVecCos=pVecCos;
eqInfor(i).sVecCos=sVecCos;
eqInfor(i).pPhaCos=pPhaCos;
eqInfor(i).sPhaCos=sPhaCos;
eqInfor(i).pPhase=PPhase;
eqInfor(i).sPhase=SPhase;
eqInfor(i).p0Vector=eqXD(i).p0Vector;
eqInfor(i).pdVector=eqXD(i).pdVector;
eqInfor(i).s0Vector=eqXD(i).s0Vector;
eqInfor(i).isDete=eqXD(i).isDete;
eqInfor(i).dep=str2num(eqXD(i).dep);
eqInfor(i).dis=str2num(eqXD(i).dis);
eqInfor(i).pF1=pF1;
eqInfor(i).pF2=pF2;
eqInfor(i).pF3=pF3;
eqInfor(i).sF1=sF1;
eqInfor(i).sF2=sF2;
eqInfor(i).sF3=sF3;
if pCount~=0
pVec(i)=sum(pVecCos)/pCount;
pPha(i)=sum(pPhaCos)/pCount;
pAbsVec(i)=sum(abs(pVecCos))/pCount;
end
if sCount~=0
sVec(i)=sum(sVecCos)/sCount;
sPha(i)=sum(sPhaCos)/sCount;
sAbsVec(i)=sum(abs(sVecCos))/sCount;
end
end
compXD.pVec=pVec;
compXD.sVec=sVec;
compXD.pPha=pPha;
compXD.sPha=sPha;
compXD.pAbsVec=pAbsVec;
compXD.sAbsVec=sAbsVec;
compXD.eqInfor=eqInfor;
%compXD.pF1=pF1;
%compXD.pF2=pF2;
%compXD.pF3=pF3;
%compXD.sF1=sF1;
%compXD.sF2=sF2;
%compXD.sF3=sF3;
save compXD compXD;
