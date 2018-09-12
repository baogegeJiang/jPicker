for i=1:100
    dep=i;
    phaseMat(i)=100;
 for j=1:20
    deg=0.4+0.05*j;
    temp=tauptimeJ('dep',dep,'ph','p,P,Pn','deg',deg);
    if strcmp(temp(1).phase,'P');phaseMat(i)=deg;break;end
 end
end
save phaseMat phaseMat
