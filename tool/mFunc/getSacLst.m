function [sacLst]=getSacLst(sacDir)
staLst=dir([sacDir,'*E']);
for i=1:length(staLst);
fileName=staLst(i).name;
fileParts=cutby(fileName,'.');
net=fileParts{1};
sta=fileParts{2};
timeStr=fileParts{3};
sacLst(i).sta=sta;
sacLst(i).net=net;
sacLst(i).day=timeStr(1:7);
sacLst(i).fileE=[sacDir,'/',fileName];
fileN=dir([sacDir,net,'*',sta,'*',timeStr(1:7),'*N']);
sacLst(i).fileN=[sacDir,'/',fileN.name];
fileZ=dir([sacDir,'/',net,'*',sta,'*',timeStr(1:7),'*Z']);                                                                                 
sacLst(i).fileZ=[sacDir,'/',fileZ.name];
end
if length(staLst)==0;sacLst=[];end
