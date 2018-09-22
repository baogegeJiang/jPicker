function [PS,rms] = jLoc(quake,staLst,r)

pTime=quake.pTime;
sTime=quake.sTime;
[m,n]=size(pTime);
if n>m;
  pTime=pTime';
  sTime=sTime';
end
L=find(pTime~=0);
pTime=pTime(L);
sTime=sTime(L);
staLst=staLst(L);
[tmpTime,index]=sort(pTime);
PS=zeros(4,1);rms=inf;
if length(pTime)==0;return;end
oTime0=tmpTime(1);La=staLst(index(1)).la+rand*0.5;Lo=staLst(index(1)).lo+rand*0.5;oTime=0;dep=20;
try
    if quake.PS(1)~0;
        oTime0=quake.PS(1);
    end
    if quake.PS(2)~0;
        La=quake.PS(2);
    end
    if quake.PS(3)~0;
        Lo=quake.PS(3);
    end
    if quake.PS(4)~0;
        dep=quake.PS(4);
    end
end

pL=find(pTime~=0);
sL=find(sTime~=0);
rL=[pL*0+1;sL*0+r];
timeL=([pTime(pL);sTime(sL)]-oTime0)*86400;
staL=[pL;sL];
staLa=[];
staLo=[];

for i=staL'
    staLa(1,end+1)=staLst(i).la;
    staLo(1,end+1)=staLst(i).lo;
end
phaseL=[pL*0+1;sL*0+2];
PS=zeros(4,1);rms=inf;lambda=10;

if length(phaseL)<4;%fprintf('not enough data\n');
return;end


eqCount=0;
for loop=1:200
    
    [time,G]=taupnetL(1,[La+staLa*0;Lo+staLa*0;dep+staLa*0;staLa;staLo;],phaseL);
    
    time=time+oTime;
    
    dTime=timeL-time;
    oTime=mean(dTime)+oTime;
    dTime=dTime-mean(dTime);
    dTime=dTime.*rL;
    G=G.*rL';
    tlG=G(1:2,:);
    dd=0.5;
    if rms<length(dTime)^0.5*10 && length(dTime)>8
        n=4;
        dd=0.1;
    else
        n=20;
    end
    gL=find(abs(dTime)<(norm(dTime)/length(dTime)^0.5)*n);
    depG=G(3,:)';
    if loop>20
        nGL=norm(dTime(gL));
        if nGL>=rms
            eqCount=eqCount+1;
            if eqCount>10
                break;
            end
        end
        if nGL<rms &&length(gL)>4
            rms=nGL;
        end
        if rms/length(gL)^0.5<20
            lambda=5;
        end
        if rms/length(gL)^0.5<10
            lambda=0.1;
        end
        if rms/length(gL)^0.5<5
            lambda=0.01;
        end
        if rms/length(gL)^0.5<1
            lambda=0.000001;
        end
        if rms/length(gL)^0.5<0.1
            break
        end
        if length(gL)>4
            dTime(find(abs(dTime)>6))=0;
            dTime=dTime-mean(dTime);
            dTime=dTime(gL);
            tlG=tlG(:,gL);
            depG=G(3,gL)';
        end
        
    end
    
    GG=tlG*tlG'+[lambda,0;0,lambda];
    dtl=GG^(-1)*(tlG*dTime);
    
    
    La=La+max(-0.1,min(0.1,dd*dtl(1))); Lo=Lo+max(-0.1,min(0.1,dd*dtl(2)));
    
    if loop>10 && mod(loop,2)==1
        
        depR=depG'*dTime/(depG'*depG+0.000001);
        dep1=min(90,max(1,dep+10*(rand-0.5+sign(depR)*0.4)));
        [time1,G]=taupnetL(1,[La+staLa*0;Lo+staLa*0;dep1+staLa*0;staLa;staLo;],phaseL);
        time1=time1+oTime;
        
        dTime1=timeL-time1;
        dTime1=dTime1-mean(dTime1);
        dTime1=dTime1.*rL;
        G=G.*rL';
        tlG=G(1:2,:);
        if loop>20
            if length(gL)>4
                dTime1(find(abs(dTime)>6))=0;
                dTime1=dTime1(gL);
                tlG=tlG(:,gL);
            end
        end
        GG=tlG*tlG'+[lambda,0;0,lambda];
        dtl=GG^(-1)*(tlG*dTime1);
        La1=La+max(-0.1,min(0.1,dd*dtl(1))); Lo1=Lo+max(-0.1,min(0.1,dd*dtl(2)));
        [time1,~]=taupnetL(1,[La1+staLa*0;Lo1+staLa*0;dep1+staLa*0;staLa;staLo;],phaseL);
        time1=time1+oTime;
        dTime1=timeL-time1;
        dTime1=dTime1-mean(dTime1);
        if loop>20
            if length(gL)>4
                dTime1(find(abs(dTime)>6))=0;
                dTime1=dTime1-mean(dTime1);
            end
        end
        rms1=norm(dTime1(gL));
        
        if rms1<rms
            dep=(dep1*3+dep)/4;
            La=La1;
            Lo=Lo1;
        end
    end
    
    if loop>10 && mod(loop,2)==0
        La1=La+1*rand-0.5;Lo1=Lo+1*rand-0.5;
        [time1,G]=taupnetL(1,[La1+staLa*0;Lo1+staLa*0;dep+staLa*0;staLa;staLo;],phaseL);
        time1=time1+oTime;
        
        dTime1=timeL-time1;
        dTime1=dTime1-mean(dTime1);
        dTime1=dTime1.*rL;
        G=G.*rL';
        tlG=G(1:2,:);
        if loop>20
            if length(gL)>4
                dTime1(find(abs(dTime)>6))=0;
                dTime1=dTime1(gL);
                tlG=tlG(:,gL);
            end
        end
        GG=tlG*tlG'+[lambda,0;0,lambda];
        dtl=GG^(-1)*(tlG*dTime1);
        La1=La1+max(-0.5,min(0.5,dd*dtl(1))); Lo1=Lo1+max(-0.5,min(0.5,dd*dtl(2)));
        [time1,~]=taupnetL(1,[La1+staLa*0;Lo1+staLa*0;dep+staLa*0;staLa;staLo;],phaseL);
        time1=time1+oTime;
        dTime1=timeL-time1;
        dTime1=dTime1-mean(dTime1);
        if loop>20
            if length(gL)>4
                dTime1(find(abs(dTime)>6))=0;
                dTime1=dTime1-mean(dTime1);
            end
        end
        rms1=norm(dTime1(gL));
        
        if rms1<rms
            %dep=(dep1*3+dep)/4;
            La=La1;
            Lo=Lo1;
        end
    end
    
end
PS=[oTime0+oTime/86400;La;Lo;dep];
rms=rms/length(phaseL)^0.5;
if rms>20
%    PS=zeros(4,1);rms=inf;
     [time,G]=taupnetL(1,[La+staLa*0;Lo+staLa*0;dep+staLa*0;staLa;staLo;],phaseL);
     time=time+oTime;
     dTime=timeL-time;
     oTime=mean(dTime)+oTime;
     dTime=dTime-mean(dTime);     
     if length(find(abs(dTime)<6))<4
        PS=zeros(4,1);rms=inf;
     end
%    fprintf('no  Convergence\n');
end

return


