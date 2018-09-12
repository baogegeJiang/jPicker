% to generate a mat file saving the velocity structure in tool/mattaup/iasp91.tvel
setPath;
aspModelFile=[workDir,'/tool/mattaup/iasp91.tvel'];
modelLocalMat=[workDir,'/tool/mattaup/modelLocalasp.mat'];
modelLocal=taupcreate(aspModelFile);
save(modelLocalMat,'modelLocal');
