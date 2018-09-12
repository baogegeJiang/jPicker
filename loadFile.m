% creat global variable assigned to existed mat file to accelerate
setPath;
setPara;
try tmp=sDay0;catch sDay0=sDay;end
tmp=tauptime('dep',1,'deg',1);
sacDir=dataDir;
mattaupDir=[workDir,'/tool/mattaup/'];
fkModelFile=[mattaupDir,'fk.tvel'];
modelLocalMat=[mattaupDir,'modelLocalasp.mat'];
netPFile=[mattaupDir,'netP.mat'];
netSFile=[mattaupDir,'netS.mat'];
global velNG
velNG=mod(sDay0,paraNum)+1;
load(netPFile);load(netSFile);
global netPG;global netSG;
netPG=netP;netSG=netS;

load(modelLocalMat);
global modelLocalG
modelLocalG=modelLocal;

clear staLst
loadSta;
global staLstG
staLstG=staLst;

global quake0G;
load quake0Sim;
quake0G=quake0;

global taupMatPG taupMatSG
load taupMatP
load taupMatS
taupMatPG=taupMatP;
taupMatSG=taupMatS;
clear quake0 modelLocal
try
   load timeLst
   global timeLstG
   timeLstG=timeLst;
end

if exist(matDir,'file')==0;
mkdir(matDir);
end

