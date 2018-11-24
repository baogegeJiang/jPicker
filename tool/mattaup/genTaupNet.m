taupMatP=zeros(4000,200);
taupMatS=zeros(4000,200);
for i=1:4000
    deg=(i-1)*0.005;
    i
    for j=1:200 
        
        dep=j;
        %[taupMatP(i,j),taupMatS(i,j)]=getTime(dep,deg);
        temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','p,P,Pn');
        taupMatP(i,j)=temp(1).time;
        temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','s,S,Sn');
         taupMatS(i,j)=temp(1).time;
      end
end
save tool/mattaup/taupMatP taupMatP
save tool/mattaup/taupMatS taupMatS
