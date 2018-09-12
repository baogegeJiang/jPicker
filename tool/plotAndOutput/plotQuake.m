function[quake]=plotQuake(sta,modPhase,modP,doAgain,quake,comp)
%% to detect quakes and determine the arrival time for each phase
setPara;
setPath;
toDoLst=[1,1,1,1];
global netPG netSG;
global modelLocalG;
warning off all
isPhaseA=[0:0];
sta0=sta;
minPrePS=0.3;PSL=50;
minDT=2/86400;minDT0=2/86400;
arN=3;
dd1=0.2;dd2=0.05;dd3=0.05;
delta=0.02;
secC=zeros(24*3700,length(sta));
secCMin=zeros(24*3700,length(sta));
secCMax=zeros(24*3700,length(sta));
minDet=3;minD=40;minIsP=0.25;
sta=sta0;
fprintf('start plot\n');
[loc res]=locQuake(quake,1.5);
oTimeDif=oTimeD(quake);
clf;
for tmpIndex=1:length(sta)
   if sta(tmpIndex).isF==1;break;end
end
dateS=datestr(sta(tmpIndex).bNum,30);
dateS=dateS(1:8);
disLst=zeros(length(sta),1)+10000;
for i=1:length(quake)
    hold off; clf;hold on;
    if loc(1,i)==0;continue;end
    if sum(sign(quake(i).pTime))<3;continue;end
    [pL,pLIndex]=sort(quake(i).pTime);
    oTime=inf;sTime=0;index1=1;pT=inf;
     for j=1:length(quake(i).pTime);
         if quake(i).pTime(j)==0;continue;end
         if quake(i).pTime(j)<pT;index1=j;pT=quake(i).pTime(j);end
         oTime=min(oTime,calOTime(quake(i).pTime(j),quake(i).sTime(j)));
         sTime=max(sTime,quake(i).sTime(j));
     end
     if loc(1,i)~=0;
       for j=1:length(sta)
           try
           disLst(j)=distaz(sta(j).la,sta(j).lo,loc(2,i),loc(3,i));%oTime=loc(1,i);
           end
        end
           [pL,pLIndex]=sort(disLst);
     else
           [pL,pLIndex]=sort(staDis(:,index1));
     end
     bTime=oTime-10/86400;eTime=sTime+30/86400;
     if eTime<bTime; continue;end 
     xlim([0,(eTime-bTime)*86400]);
     ylim([0,length(sta)+0.5]);
     plot([0,(eTime-bTime)*86400,(eTime-bTime)*86400],[length(sta)+0.5,length(sta)+0.5,0],'k');
     xlabel('t/s','fontsize',10);
     ylabel('stations','fontsize',10);
     for k=1:length(quake(i).pTime);
          j=pLIndex(k); 
         if sta(j).isF==0;continue;end
         bNum=sta(j).bNum;
         bIndex=max(1,ceil((bTime-bNum)*86400/delta)+1);
         bIndex0=ceil((bTime-bNum)*86400/delta)+1;
         eIndex=ceil(min(length(sta(j).data),(eTime-bNum)*86400/delta+1));
         if eIndex-bIndex<=10;continue;end
         if bIndex<=0 || eIndex <=0;continue;end
         if max(abs(sta(j).data(bIndex:eIndex,3)))<=0;continue;end
         plot(([bIndex:eIndex]-bIndex0)*delta,k-0.5+0.45*sta(j).data(bIndex:eIndex,comp)/max(abs(sta(j).data(bIndex:eIndex,comp))),'Color',[0.5,0.5,0.5]);
         F2=[];
         F=[];
         s=sta(j).data([bIndex:eIndex+200],3);
         sd=sta(j).data([bIndex:eIndex+200]-1,3)-sta(j).data([bIndex:eIndex+200],3);
         s=s.^2;sd=sd.^2;
%         for l=bIndex:eIndex  
%             F(l-bIndex0+1)=(sum(sd(l-bIndex+[1:100]))/sum(s(l-bIndex+[1:100])))^0.5;                                                                                                       
%         end
         %F=sta(j).slrDataZ(bIndex:eIndex);
       % plot(([bIndex:eIndex]-bIndex0)*delta,k-0.5+0.45*F/max(F),'Color',[0.2 0.2 0.2]); 
       % plot(([bIndex:eIndex]-bIndex0)*delta,k-0.5+0.45*F/max(F),'Color',[0.2 0.2 0.2]); 
%         XD=conXD(bIndex:eIndex,sta(j).data);
%         for l=bIndex:eIndex
%             temp=calXD(XD(:,l-bIndex+1));
%             F2(l-bIndex0+1)=temp.F2;
%         end
%         plot(([bIndex:eIndex]-bIndex0)*delta,k-0.5+0.45*F2,'Color',[0.2 0.2 0.2]);
sBIndex=bIndex;sEIndex=eIndex;
         if quake(i).pTime(j)* quake(i).sTime(j)~=0;
         pTime=((quake(i).pTime(j)-bNum)*86400/delta-bIndex0)*delta;
         sTime=((quake(i).sTime(j)-bNum)*86400/delta-bIndex0)*delta;
         spTime=((calOTime(quake(i).pTime(j),quake(i).sTime(j))-bNum)*86400/delta-bIndex0)*delta;
        hP= plot([pTime,pTime],[k-1.2,k+0.2],'b');
        hS= plot([sTime,sTime],[k-1.2,k+0.2],'r');
%         plot([spTime,spTime],[k-1.2,k+0.2],'g');
         sBIndex=bIndex;sEIndex=eIndex;
         pIndex=(quake(i).pTime(j)-bNum)*86400/delta;
             sIndex=floor((quake(i).sTime(j)-bNum)*86400/delta); 
        % pXD=conXD2(pIndex,sta(j).data,min(100,floor((sIndex-pIndex)/2)));
             sIndex=floor((quake(i).pTime(j)-bNum)*86400/delta); 
             sBIndex=sIndex-500;sEIndex=sIndex+2000;
           %  sXD=conXD([sBIndex:sEIndex]-25,sta(j).data);
             %F=calF2(pXD,sXD);%F=F.*(exp(5*(-sta(j).slrDataZ([sBIndex:sEIndex])+1))+1).^(-1);
        %     [x,tmp]=conVector([sBIndex:sEIndex],sta(j).data);
  %^          F=preT(x,modPhase);F=(1+exp(-F)).^(-1);
   %          plot(([sBIndex:sEIndex]-bIndex0)*delta,k-0.5+0.45*F/max(abs(F)),'Color',[0 0 0.6]);
%             F=F.*(sign(sta(j).slrDataZ([sBIndex:sEIndex])-2)+1)'/2;
            % min((sign(sta(j).slrDataZ([sBIndex+500:sEIndex-2000]-25)-4.5)+1)/2)
             %size(F)
           %  F=preT([pXD+0*sXD;sXD],modP); 
%end
%             plot(([sBIndex:sEIndex]-bIndex0)*delta,k-0.5+0.45*F/max(abs(F)),'Color',[0.2 0.2 0.2]);
      %      plot(([sBIndex:sEIndex]-bIndex0)*delta,k-0.5+0.45*sign(F+1000)*0.5/max(abs(F)),'Color',[0.2 0.2 0.2]);  
      %      plot(([sBIndex:sEIndex]-bIndex0)*delta,k-0.5+0.45*sign(F+1000)*0.7/max(abs(F)),'Color',[0 0.2 0.2]);
              
         end
        if loc(1,i)~=0
              try
              pTime=taupnet(netPG,[loc(2:4,i);sta(j).la;sta(j).lo],1)/86400+loc(1,i);
              sTime=taupnet(netSG,[loc(2:4,i);sta(j).la;sta(j).lo],2)/86400+loc(1,i);
               catch
               continue;
               end
              pTime=((pTime-bNum)*86400/delta-bIndex0)*delta;
              sTime=((sTime-bNum)*86400/delta-bIndex0)*delta;
              spTime=((calOTime(pTime,sTime)-bNum)*86400/delta-bIndex0)*delta;
      %   plot([pTime,pTime],[k-1.1,k+0.1],'o-b');
      %   plot([sTime,sTime],[k-1.1,k+0.1],'o-r');
      %   plot([spTime,spTime],[k-1.1,k+0.1],'.-g');
        hP0= plot([pTime],[k-0.5],'ob');
        hS0= plot([sTime],[k-0.5],'or');
         end
     end
     figName=sprintf('%s/output/quakeFigure/%s_%d(v6).pdf',workDir,dateS,i);
     %title(sprintf('quake %d %s  la %.1f lo %.1f dep:%.1f ml %.1f',i,datestr(oTime),loc(2,i),loc(3,i),quake(i).PS(4),quake(i).PS(5)));
     try legend([hP0,hS0,hP,hS],{'pTimeTheor','sTimeTheor','pTime','sTime'});end
%     title(sprintf('la %.1f lo %.1f dep:%.1f ml %.1f',loc(2,i),loc(3,i),loc(4,i),quake(i).PS(5)),'fontsize',10);
    set(gca,'ytick',[1:2:16]-0.5,'yticklabel',{'1','3','5','7','9','11','13','15'});
    saveas(gcf,figName);
%    print(gcf,figName,'-djpeg','-r300');
   fprintf('%d\n',i);
     hold off
end

end
