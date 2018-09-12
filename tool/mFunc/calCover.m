function [coverRate,coverL,errLa,errLo] =calCover(quake, staLst)
coverL=zeros(360,1);

for i=1:length(quake.pTime)
     if quake.pTime(i)==0;continue;end
    [dk ,dd,az]=distaz(quake.PS(2),quake.PS(3),staLst(i).la,staLst(i).lo);
    R=45/(1+dk/50)+45;
    N=mod(floor(az+(-R:R))-1,360)+1;
    coverL(N)=1+coverL(N);
end
L=mod([1:360]+180-1,360)+1;
coverL=sign(coverL).*sign(coverL(L)).*(coverL+coverL(L));
coverRate=length(find(coverL>0))/360;
L=find(coverL==0);
errLa=sum(abs(sin(L/180)))/360;
errLo=sum(abs(cos(L/180)))/180;

