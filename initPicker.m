setPara;
setPath;
addpath(genpath(workDir));
loadSta;
staVel;
load  machineIsPhaseHimaV3
load machineIsP
%machineIsPhase.x=single(machineIsPhase.x);
%machineIsPhase.a=single(machineIsPhase.a);
%machineIsPhase.b=single(machineIsPhase.b);
%machineIsP.a=single(machineIsP.a);
%machineIsP.b=single(machineIsP.b);
%machineIsP.x=single(machineIsP.x);
if isJLoc==0
velDir=[workDir,'tool/tmpVEL/'];
if exist(velDir,'file');
   rmpath(genpath(velDir));
   rmdir(velDir,'s');
end
mkdir(velDir);
for i=1:paraNum
    velDirTmp=[velDir,'VELSVM',num2str(i)];
    if exist(velDirTmp,'file');
       rmdir(velDirTmp);
    end
    unix(sprintf('cp -r %s %s',velDir0,velDirTmp));
%    cd(velDirTmp);
%    unix(sprintf(' bash %s/matrun.bash ./velest3',velDirTmp));
%    cd(workDir);
end
end
setPath
loadFile;
