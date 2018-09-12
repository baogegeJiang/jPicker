taupMatP=zeros(2000,100);
taupMatS=zeros(2000,100);
for i=1:2000
    deg=(i-1)*0.005;
    i
    for j=1:100 
        dep=j;
        temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','p,P,Pn');
        taupMatP(i,j)=temp.time;
        temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','s,S,Sn');
         taupMatS(i,j)=temp.time;
      end
end
save tool/mattaup/taupMatP taupMatP
save tool/mattaup/taupMatS taupMatS
