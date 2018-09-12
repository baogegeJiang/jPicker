%% plot pTime and sTime
if 0
pTime=[];sTime=[];
clf
for i=1:length(day)
    for j=1:length(day(i).quake)
        if sum(sign(day(i).quake(j).pTime.*day(i).quake(j).sTime))<=6;continue;end
        P=[];S=[];
        for k=1:length(day(i).quake(j).pTime)
            if day(i).quake(j).pTime(k)*day(i).quake(j).sTime(k)==0;continue;end 
            P=[P;day(i).quake(j).pTime(k)-day(i).quake(j).PS(1)];
            S=[S;day(i).quake(j).sTime(k)-day(i).quake(j).PS(1)];
        end
        tmp=polyfit(P,S,1);
        oTime=tmp(2)/(1-tmp(1))+day(i).quake(j).PS(1);
        for k=1:length(day(i).quake(j).pTime)
            if day(i).quake(j).pTime(k)*day(i).quake(j).sTime(k)==0;continue;end
            if sum(sign(day(i).quake(j).pTime))<=8;continue;end
            pTime=[pTime,day(i).quake(j).pTime(k)-oTime];
            sTime=[sTime,day(i).quake(j).sTime(k)-oTime];
         end
     end
end
plot(pTime*86400,sTime*86400,'.'); hold on;
x0=[0:80];y0=tmp(1)*x0+tmp(2)*86400;
plot(x0,y0,'r');
legend({'PS pairs','fitting result'});
tmp=polyfit(pTime,sTime,1);
xlim([-1,70]);
ylim([0,120]);
xlabel('p travel time/s');
ylabel('s travel time/s');
text(5,110,sprintf('sTime=%4.2f*pTime+%.3f',tmp(1),tmp(2)*86400));
title('relationship between pTime and sTime');
figName='/home/jiangyr/figure/PS.jpg';
print(gcf,figName,'-djpeg','-r300');
end
%saveas(gcf,'/home/jiangyr/figure/PS.pdf');

%%plot by distance
%load daySC
%for i=1:0%length(day)
%    for j=1:length(day(i).quake)
%        day(i).quake(j).PS(2:4)=[day(i).quake(j).la,day(i).quake(j).lo,day(i).quake(j).dep];
%    end
%end
%load staLst
%plot quake stations
qCount=0;
for i=1:1%length(day)
%    load(sprintf('/DATA/jiangyr/STADIR/sta_%dV3.mat',i+183-1));
    for j=1:length(day(i).quake)
        clf
        fprintf('day %d;quake:%d;qCount:%d\n',i,j,qCount);
        sPos=[];sL=[];
        if sum(sign(day(i).quake(j).pTime))<8;continue;end
           quake=day(i).quake(j);
           quake.PS(1:4)=loc(1:4,j);
        for k=1:length(staLst)
            if quake.pTime(k)==0;continue;end
            %if pIndex<1000||pIndex>length(sta(k).data)-5000;continue;end
            dis=distaz(staLst(k).la,staLst(k).lo,quake.PS(2),quake.PS(3));
            oY=(dis^2+quake.PS(4)^2)^0.5;A=1;    
            oY=(quake.pTime(k)-loc(1,j))*86400;
            pIndex=ceil((quake.pTime(k)-sta(k).bNum)*86400*50)+1;
            if pIndex<1000||pIndex>length(sta(k).data)-5000;continue;end
            L=[-500:2500];
            plot(L/50,sta(k).data(pIndex+L,1)*A/max(abs(sta(k).data(pIndex+L,3)))+oY,'b');hold on;
            plot(([pIndex pIndex]-pIndex)/50,[-A,A]*1.5+oY,'k');
            if quake.sTime(k)~=0
               sIndex=ceil((quake.sTime(k)-sta(k).bNum)*86400*50)+1;
               plot(([sIndex sIndex]-pIndex)/50,[-A,A]*1.5+oY,'r');
            end
            if dayPhase0(1).sta(k,1).timeCount*dayPhase0(1).sta(k,2).timeCount~=0
            temp=dayPhase0(1).sta(k,1).time-quake.pTime(k);
            [minTD,index]=min(abs(temp));pTime=dayPhase0(1).sta(k,1).time(index);
            temp=dayPhase0(1).sta(k,2).time-quake.sTime(k);
            [minTD,index]=min(abs(temp));sTime=dayPhase0(1).sta(k,2).time(index);
            pIndex0=ceil((pTime-sta(k).bNum)*86400*50)+1;
            plot(([pIndex0 pIndex0]-pIndex)/50,[-A,A]*1.5+oY,'-*m');
            if sTime~=0
               sIndex0=ceil((sTime-sta(k).bNum)*86400*50)+1;
               plot(([sIndex0 sIndex0]-pIndex)/50,[-A,A]*1.5+oY,'-*c');
            end
            end
        end 
        xlim(L([1,end])/50);
        title(sprintf('day:%d ;quake:%d',i-1+183,j));
        qCount=qCount+1;
        print(gcf,sprintf('/home/jiangyr/figure/quake%d_%d',i,qCount),'-djpeg','-r400'); 
    end
end
