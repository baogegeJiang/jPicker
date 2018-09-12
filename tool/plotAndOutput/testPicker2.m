setPath;
loadFile;
day=day(1);
%load day1202
%outputQuakeV4;
dayPhase=readPhaseLst([workDir,'/output/phaseLstALL'],datenum(2008,07,1));
dayPhase0=readPhaseLst([workDir,'/output/phaseLst0'],datenum(2008,07,1));
delta=0.02;
loadSta;
dayS=num2str(sDay);
%fprintf( 'workding on %s day ', dayS);
perCount=0;
filename=sprintf('%s/sta_%dV3.mat',matDir,sDay);
%load(filename);
%load day1202
dH=0;
quake=day(sDay-sDay+1).quake;
for i=1:length(quake)
    quake0(i).pTime=quake(i).pTime+dH/24.*sign(quake(i).pTime);
    quake0(i).sTime=quake(i).sTime+dH/24.*sign(quake(i).sTime);
    quake0(i).PS=[0 0 0 0 0];
end
%loc=locQuake(quake0,2);

   
clear resPicker
count=0;dpT=[];dsT=[];
for i=[329,357]%1:length(quake)
    if sum(sign(quake(i).pTime))<3;continue;end
    for j=1:length(sta)
        if quake(i).pTime(j)*quake(i).sTime(j)==0;continue;end
        if loc(1,i)==0;continue;end
        count=count+1;
        fprintf('phase pair %3d_%3d: ;tPS = %5.2f s;',i,count,(quake(i).sTime(j)-quake(i).pTime(j))*86400)
        bNum=sta(j).bNum;
        pIndex=ceil((quake(i).pTime(j)-bNum)*86400*50);
        sIndex=ceil((quake(i).sTime(j)-bNum)*86400*50);
         temp=dayPhase(1).sta(j,1).time-quake(i).pTime(j);
         [minTD,index]=sort(abs(temp));index=index(2);pTimeB=dayPhase(1).sta(j,1).time(index);
         temp=dayPhase(1).sta(j,2).time-quake(i).sTime(j);
         [minTD,index]=sort(abs(temp));index=index(2);sTimeB=dayPhase(1).sta(j,2).time(index);
        toDoLst=[1,1,1,0];
         temp=dayPhase0(1).sta(j,1).time-quake(i).pTime(j);
         [minTD,index]=min(abs(temp));pTime=dayPhase0(1).sta(j,1).time(index);pTime1=dayPhase0(1).sta(j,1).time(max(1,index-1));
         temp=dayPhase0(1).sta(j,2).time-quake(i).sTime(j);
         [minTD,index]=min(abs(temp));sTime=dayPhase0(1).sta(j,2).time(index);sTime1=dayPhase0(1).sta(j,2).time(max(1,index-1));
        dp=(pTime-quake(i).pTime(j))*86400;
        ds=(sTime-quake(i).sTime(j))*86400;
        if plotFig==1
           if count>20 & abs(dp)>2;continue;end
           
           pIndex0=pIndex;
           sIndex0=sIndex;
           pIndex=ceil((pTime-bNum)*86400*50);
           sIndex=ceil((sTime-bNum)*86400*50);
           pIndex1=ceil((pTime1-bNum)*86400*50);
           sIndex1=ceil((sTime1-bNum)*86400*50);
           pIndexB=ceil((pTimeB-bNum)*86400*50);
           sIndexB=ceil((sTimeB-bNum)*86400*50);
           L=[pIndex0-1500:sIndex0+750];
           clf
           hAxes=axes;
           waveData=sta(j).data(L,:);
           [x,xd]=conVector(L,sta(j).data);
           x=preT(x,machineIsPhase);
           x=(1+exp(-x)).^(-1);
           xd=[(xd*0+xd(:,1500));xd];
           xd=preT(xd,machineIsP);%+0.5;
           comX=x.*sign(xd);
           AD=max(abs(xd));
           pData=[x*0.5,xd/max(abs(xd))*0.5,comX*0.5];
           A=max(max(abs(waveData)));
           textStr={'p(isPhase)','p(isP)','p(isPhase)*sign(p(isP))'};
           cmpStr={'BHE','BHN','BHZ'};
           pColor={'k','c','g'};
           isPlot=0;
           for cmp=1:3
               oY=3-cmp;
               hWave=plot(L/50,waveData(:,cmp)/A*0.7+oY,'Color',[0.4 0.4 0.4]);hold on; 
          %    if sum(sign(day(i).quake(j).pTime))<=8;continue;end
               isPlot=1;
               hP=plot([pIndex0,pIndex0]/50,[-0.4,0.4]+oY,'r','LineWidth',1);
               hS=plot([sIndex0,sIndex0]/50,[-0.4,0.4]+oY,'b','LineWidth',1);
              % hP0=plot([pIndex0,pIndex0]/50,[-0.4,0.4]+oY,'or');
              % hS0=plot([sIndex0,sIndex0]/50,[-0.4,0.4]+oY,'ob');
               hPo(cmp)=plot(L/50,pData(:,cmp)+oY,pColor{cmp});
               if cmp~=2
                  hThes=plot(L(1:30:end)/50,L(1:30:end)*0+0.25+oY,'m');
                  plot(L(1:30:end)/50,L(1:30:end)*0-0.25+oY,'m');
               else
                  hThes=plot(L(1:30:end)/50,L(1:30:end)*0+0.5/AD*0.5+oY,'m');
                  plot(L(1:30:end)/50,L(1:30:end)*0-0.5/AD*0.5+oY,'m');
               end
               plot([pIndexB,pIndexB,pIndexB]/50,[-0.4,0,0.4]+oY,'-r','LineWidth',1);
               plot([sIndexB,sIndexB,sIndexB]/50,[-0.4,0,0.4]+oY,'-b','LineWidth',1);
            %   text(L(1)/50-1,oY+0.15,textStr{cmp});
            %   text(L(1)/50-1,oY-0.15,cmpStr{cmp});
               findP=0;findS=0;
               if abs(dp)<10
                  findP=1;
                  hP0=plot([pIndex,pIndex]/50,[-0.4,0.4]+oY,'-.r','LineWidth',1);
                  hP0=plot([pIndex,pIndex]/50,[-0.4,0.4]+oY,'or','LineWidth',1);
                  plot([pIndex1,pIndex1]/50,[-0.4,0.4]+oY,'r','LineWidth',1);
               end
               if abs(ds)<10
                  findS=1;
                  plot([sIndex1,sIndex1]/50,[-0.4,0.4]+oY,'b','LineWidth',1);
                  hS0=plot([sIndex,sIndex]/50,[-0.4,0.4]+oY,'-.b','LineWidth',1);
                  hS0=plot([sIndex,sIndex]/50,[-0.4,0.4]+oY,'ob','LineWidth',1);
               end
           end
           if isPlot==1
              title(sprintf('quake:%d phase pair: %d; dp=%4.2fs;ds=%4.2fs',i,count,dp,ds)); 
              box off
              X0=L([1,end-20])/50;Y0=[-0.6,2.8];
              xlim(X0);
              ylim(Y0);
              xlabel('time/s','FontSize',10);
              ylabel('component','FontSize',10);
              set(gca,'ytick',[0,1,2]);
              set(gca,'yticklabel',{'BHZ','BHN','BHE'},'FontSize',10);
             % hl=legend([hWave,hP0,hS0,hP,hS,hPo,hThes],{'waveform','pTime0','sTime0','pTime','sTime',...
             %'p(isPha)','isP','p(isPha,isP)','0.5'},'Location','SouthOutside');
              hLst=[hWave,hP,hS];lLst={'waveform','pTime','sTime'};
              if findP>0;hLst=[hLst,hP0];lLst{end+1}='pTime0';end
              if findS>0;hLst=[hLst,hS0];lLst{end+1}='sTime0';end
              hL1=legend(hLst,lLst,'Location','SouthOutside','FontSize',10);
              set(hL1,'Orientation','horizon');
              ah=axes('position',get(gca,'position'),...
           'visible','off');
              hAxes2=ah;
              hL2=legend(ah,[hPo,hThes],{ 'p(isPha)','isP','p(isPha,IsP)','0.5,-0.5'},'FontSize',10);
              box off
              set(hL2,'Orientation','horizon');
              set(hAxes,'Position',[0.1,0.1,0.8,0.8],'Units','normalized');
              set(ah,'Position',[0.1,0.1,0.8,0.8],'Units','normalized');
              ah1=get(hL1,'position');
              set(hL1,'Box','off');
              ah1(1:2)=[0.11,0.899-ah1(4)];
              ah2=get(hL2,'position');
              ah2(1:2)=ah1(1:2)-[0 ah1(4)];
              set(hL2,'position',ah2,'Box','off');
              set(hL1,'position',ah1,'Box','off');
              ah0=get(hAxes,'position');
              axes(hAxes);
              ah1(3)=max(ah1(3),ah2(3));
              plotRec([X0(1)+(ah2(1)-ah0(1))/ah0(3)*(X0(2)-X0(1)),...
              Y0(1)+(ah2(2)-ah0(2))/ah0(4)*(Y0(2)-Y0(1)),ah1(3)/ah0(3)*(X0(2)-X0(1)),...
               2*ah2(4)/ah0(4)*(Y0(2)-Y0(1))],'k');
              plotRec([X0(1),Y0(1),(X0(2)-X0(1)),(Y0(2)-Y0(1))],'k');
              axes(hAxes2);
              %hRec=text(1,1,'');
              %set(hText,'units','normalized','position',[ah2(1:2),ah1(3),2*ah1(4)]);
              %set(gca,'ytick',[0,1,2]);
              %set(gca,'yticklabel',{'BHZ','BHN','BHE'}); 
              figName=sprintf('%s/output/figure/phaseCmpT%d_%d.pdf',workDir,count,floor(min(abs(dp),1.99)));
             % print(gcf,figName,'-djpeg','-r400');
               saveas(gcf,figName);
          end
        end
        if abs(dp)>1;
           fprintf('no find P   ;');
        else
           dpT=[dpT;dp];
           fprintf('dp = %6.2fs;ddp=%4.2f;pPer:%5.2f%%; ',dp,...
            (dpT'*dpT/length(dpT))^0.5,length(dpT)/count*100);
        end
        if abs(ds)>1;
           fprintf('    no find S;\n');                
        else
           dsT=[dsT;ds];
           fprintf('ds = %6.2fs;dds=%4.2f;mp=%5.2f;ms=%4.2f;sPer:%5.2f%% \n',...
           ds,(dsT'*dsT/length(dsT))^0.5,mean(dpT),mean(dsT),length(dsT)/count*100); 
        end
    end
end
