taupMatP=zeros(4000,200);
taupMatS=zeros(4000,200);
parfor j=1:200
    dep=j;
    j
   % for i=1:4000 
      %  deg=(i-1)*0.005;
        
        [taupMatP(:,j),taupMatS(:,j)]=calTimeDeg(dep);
      %  temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','p,P,Pn');
      %  taupMatP(i,j)=temp(1).time;
      %  temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','s,S,Sn');
      %   taupMatS(i,j)=temp(1).time;
    %  end
end
save tool/mattaup/taupMatP taupMatP
save tool/mattaup/taupMatS taupMatS

function [tp,ts]=calTimeDeg(dep)
   setPath
   mattaupDir=[workDir,'/tool/mattaup/'];
   fkModelFile=[mattaupDir,'fk.tvel'];
   modelLocalMat=[mattaupDir,'modelLocalasp.mat'];
   load(modelLocalMat);
   global modelLocalG
   modelLocalG=modelLocal;
   for i=4000:-1:1
        deg=(i-1)*0.005;
        [tp(i,1),ts(i,1)]=getTime(dep,deg);
    end
end
