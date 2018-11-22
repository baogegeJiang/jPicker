% to generate a mat file saving the velocity structure in tool/mattaup/iasp91.tvel
%13772.  2816.08  6318.86  3670.06    0.00  600.00  6318.86  3670.06 1.00000 CRUST1-BOTTOM
setPath;
aspModelFile=[workDir,'/tool/mattaup/iasp91.tvel'];
localModelFile=[workDir,'/tool/mattaup/new.tvel'];
localModelFileNew=[workDir,'/tool/mattaup/new1.tvel'];
modelLocalMat=[workDir,'/tool/mattaup/modelLocalasp.mat'];
exe=[workDir,'/tool/mattaup/access_litho '];
tmpFile=[workDir,'/tool/mattaup/tmp'];
cmdStr=sprintf('%s -p %.3f %.3f > %s',exe,la0,lo0,tmpFile);
unix(cmdStr);
velCell=readdata(tmpFile);

velCount=0;
dep=[];p=[];s=[];rou=[];
clear newCell
for i=length(velCell):-1:1
    ii=length(velCell)-i+1;
    dep(ii)=str2num(velCell{i,1})/1000;
    rou(ii)=str2num(velCell{i,2})/1000;
    p(ii)=str2num(velCell{i,3})/1000;
    s(ii)=str2num(velCell{i,4})/1000;
end
tmpL=find(dep>0);
oL=max(1,tmpL(1)-1);
dep=dep(oL:end-1);
dep(1)=max(0,dep(1));
rou=rou(oL:end-1);
p=p(oL:end-1);
s=s(oL:end-1);
iaspCell=readdata(aspModelFile);
newCell(1:2,:)=iaspCell(1:2,:);
newCell([1:131]+2+length(dep),:)=iaspCell(10:140,:);
newCell{1,4}=sprintf('(%d',length(dep)+131);
for i=1:length(dep)
    newCell{i+2,1}=sprintf('%.3f',dep(i));
    newCell{i+2,2}=sprintf('%.4f',p(i));
    newCell{i+2,3}=sprintf('%.4f',s(i));
    newCell{i+2,4}=sprintf('%.4f',rou(i));
end
wfile(newCell,localModelFile);
cmdStr=['cp ',localModelFile,' ',localModelFileNew];
unix(cmdStr);
modelLocal=taupcreate(localModelFileNew);
save(modelLocalMat,'modelLocal');

