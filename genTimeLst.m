function [timeLst] = genTimeLst(R,n,m,staLst)
timeLst=zeros(n,m,length(staLst),2);
if n<1||m<1;return;end
dLa=(R(2)-R(1))/n;
dLo=(R(4)-R(3))/m;
La=R(1):dLa:R(2);
Lo=R(3):dLa:R(4);
deltaDeg=0.01;
for i=1:length(staLst)
    for j=1:n
        for k=1:m
            tmpLa=La(j):deltaDeg:La(j+1);
            tmpLo=Lo(k):deltaDeg:Lo(k+1);
            tmpN=length(tmpLa);tmpM=length(tmpLo);
            degL=zeros(2*tmpN+2*tmpM-4,1);
            jjL=[tmpLo(1:end-1)*0+1, 1:(length(tmpLa)-1),tmpLo(1:end-1)*0+length(tmpLa),(length(tmpLa)):-1:2];
            kkL=[1:(length(tmpLo)-1),length(tmpLo)+tmpLa(1:end-1)*0,(length(tmpLo)):-1:2,1+tmpLa(2:end)*0];
            for it=1:(2*tmpN+2*tmpM-4)
                jj=jjL(it);
                kk=kkL(it); 
                [a,degL(it),c,d]=distaz(tmpLa(jj), tmpLo(kk),staLst(i).la,staLst(i).lo);
            end
            minDeg=min(min(degL));[minIT]=find(degL==minDeg);minJJ=jjL(minIT(1));minKK=kkL(minIT(1));

            maxDeg=max(max(degL));[maxIT]=find(degL==maxDeg);maxJJ=jjL(maxIT(1));maxKK=kkL(maxIT(1));
            timeLst(j,k,i,1)=1*(taupnet(1,[tmpLa(minJJ), tmpLo(minKK),1,staLst(i).la,staLst(i).lo],2)-...
                taupnet(1,[tmpLa(minJJ), tmpLo(minKK),1,staLst(i).la,staLst(i).lo],1));
            timeLst(j,k,i,2)=1*(taupnet(1,[tmpLa(maxJJ), tmpLo(maxKK),1,staLst(i).la,staLst(i).lo],2)-...
                taupnet(1,[tmpLa(maxJJ), tmpLo(maxKK),1,staLst(i).la,staLst(i).lo],1));
            if staLst(i).la>La(j) && staLst(i).la< La(j+1)&&staLst(i).lo>Lo(k) && staLst(i).lo< Lo(k+1)
                timeLst(j,k,i,1)=0;
            end
        end
    end
end

end

