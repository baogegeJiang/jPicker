setPath;
fkModelFile=[workDir,'/tool/mattaup/fk.tvel'];
modelLocalMat=[workDir,'/tool/mattaup/modelLocal.mat'];
modelLocal=taupcreate(fkModelFile);
save(modelLocalMat,'modelLocal');
