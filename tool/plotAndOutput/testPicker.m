sacDir='/DATA/jiangyr/AIPICK/after2/';
plotFig=1;
fkModelFile='/home/jiangyr/mattaup/fk.tvel';
modelLocalMat='/home/jiangyr/mattaup/modelLocal.mat';
netPFile='/home/jiangyr/mattaup/netP.mat';
netSFile='/home/jiangyr/mattaup/netS.mat';
global velNG
velNG=mod(sDay,12)+1;
load(netPFile);load(netSFile);
global netPG;global netSG;
netPG=netP;netSG=netS;

load(modelLocalMat);
global modelLocalG
modelLocalG=modelLocal;

clear staLst
loadSta;
global staLstG
staLstG=staLst;

global quake0G;
load quake0;
quake0G=quake0;

load netPhase;
global netPhaseG;
netPhaseG=netPhase;
clear quake0 modelLocal
load day1207
day=day(1);
outputQuakeV4;
dayPhase=readPhaseLst('/home/jiangyr/jSvm/phase.csv',datenum(2008,07,1));
delta=0.02;
loadSta;
dayS=num2str(sDay);
%fprintf( 'workding on %s day ', dayS);
perCount=0;
filename=sprintf('/DATA/jiangyr/STADIR/sta_%dV3.mat',sDay);
%load(filename);
load daySC
quake=day(sDay-183+1).quake;
for i=1:length(quake)
    quake0(i).pTime=quake(i).pTime;
    quake0(i).sTime=quake(i).sTime;
    quake0(i).PS=[0 0 0 0 0];
end
loc=locQuake(quake0,2);

   
clear resPicker
count=0;dpT=[];dsT=[];
for i=1:length(quake)
    if sum(sign(quake(i).pTime))<3;continue;end
    for j=1:length(sta)
        if quake(i).pTime(j)*quake(i).sTime(j)==0;continue;end
        if loc(1,i)==0;continue;end
        count=count+1;
        fprintf('phase pair %3d_%3d: ;tPS = %5.2f s;',i,count,(quake(i).sTime(j)-quake(i).pTime(j))*86400)
        bNum=sta(j).bNum;
        pIndex=ceil((quake(i).pTime(j)-bNum)*86400*50);
        sIndex=ceil((quake(i).sTime(j)-bNum)*86400*50);
        toDoLst=[1,1,1,0];
       [pTime,sTime]=pPicker(pIndex+ceil((rand-0.5)*100),sIndex+ceil((rand-0.5)*100),sta(j), ...
        toDoLst,machineIsPhase,machineIsP);
%         temp=dayPhase(1).sta(j,1).time-quake(i).pTime(j);
%         [minTD,index]=min(abs(temp));pTime=dayPhase(1).sta(j,1).time(index);pTime1=dayPhase(1).sta(j,1).time(max(1,index-1));
%         temp=dayPhase(1).sta(j,2).time-quake(i).sTime(j);
%         [minTD,index]=min(abs(temp));sTime=dayPhase(1).sta(j,2).time(index);sTime1=dayPhase(1).sta(j,2).time(max(1,index-1));
 %       pTime=loc(1,i)+taupnet(netPG,[loc(2:4,i);staLst(j).la;staLst(j).lo],1)/86400;
 %       sTime=loc(1,i)+taupnet(netSG,[loc(2:4,i);staLst(j).la;staLst(j).lo],2)/86400; 
        dp=(pTime-quake(i).pTime(j))*86400;
        ds=(sTime-quake(i).sTime(j))*86400;
        if plotFig==1
           pIndex0=pIndex;
           sIndex0=sIndex;
           pIndex=ceil((pTime-bNum)*86400*50);
           sIndex=ceil((sTime-bNum)*86400*50);
           pIndex1=ceil((pTime1-bNum)*86400*50);
           sIndex1=ceil((sTime1-bNum)*86400*50);
           L=[pIndex0-1500:sIndex0+1500];
           clf
           hAxes=axes;
           waveData=sta(j).data(L,:);
           [x,xd]=conVector(L,sta(j).data);
           x=preT(x,machineIsPhase);
           x=(1+exp(-x)).^(-1);
           xd=[(xd*0+xd(:,500));xd];
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
               hP0=plot([pIndex0,pIndex0]/50,[-0.4,0.4]+oY,'-.r','LineWidth',1);
               hS0=plot([sIndex0,sIndex0]/50,[-0.4,0.4]+oY,'-.b','LineWidth',1);
               hP0=plot([pIndex0,pIndex0]/50,[-0.4,0.4]+oY,'or');
               hS0=plot([sIndex0,sIndex0]/50,[-0.4,0.4]+oY,'ob');
               if cmp~=2
               hPo(cmp)=plot(L/50,pData(:,cmp)+oY,pColor{cmp});
               else
                hPo(cmp)=plot(L/50,pData(:,cmp)+oY,'color',[238,118,0]/256);
               end
               if cmp~=2
                  hThes=plot(L(1:30:end)/50,L(1:30:end)*0+0.25+oY,'m');
                  plot(L(1:30:end)/50,L(1:30:end)*0-0.25+oY,'m');
               else
                  hThes=plot(L(1:30:end)/50,L(1:30:end)*0+0.5/AD*0.5+oY,'m');
                  plot(L(1:30:end)/50,L(1:30:end)*0-0.5/AD*0.5+oY,'m');
               end
            %   text(L(1)/50-1,oY+0.15,textStr{cmp});
            %   text(L(1)/50-1,oY-0.15,cmpStr{cmp});
               findP=0;findS=0;
               if abs(dp)<10
                  findP=1;
                  hP=plot([pIndex,pIndex]/50,[-0.4,0.4]+oY,'r','LineWidth',1);
                  plot([pIndex1,pIndex1]/50,[-0.4,0.4]+oY,'r','LineWidth',1);
               end
               if abs(ds)<10
                  findS=1;
                  plot([sIndex1,sIndex1]/50,[-0.4,0.4]+oY,'b','LineWidth',1);
                  hS=plot([sIndex,sIndex]/50,[-0.4,0.4]+oY,'b','LineWidth',1);
               end
           end
           if isPlot==1
              title(sprintf('quake:%d phase pair: %d; dp=%4.2fs;ds=%4.2fs',i,count,dp,ds),'fontsize',16); 
              box off
              X0=L([1,end-20])/50;Y0=[-0.6,2.8];
              xlim(X0);
              ylim(Y0);
              xlabel('time/s','FontSize',20);
              ylabel('component','FontSize',20);
              set(gca,'ytick',[0,1,2]);
              set(gca,'yticklabel',{'BHZ','BHN','BHE'},'FontSize',20);
             % hl=legend([hWave,hP0,hS0,hP,hS,hPo,hThes],{'waveform','pTime0','sTime0','pTime','sTime',...
             %'p(isPha)','isP','p(isPha,isP)','0.5'},'Location','SouthOutside');
              hLst=[hWave,hP0,hS0];lLst={'waveform','pTime0','sTime0'};
              if findP>0;hLst=[hLst,hP];lLst{end+1}='pTime';end
              if findS>0;hLst=[hLst,hS];lLst{end+1}='sTime';end
              hL1=legend(hLst,lLst,'Location','SouthOutside','FontSize',10);
              set(hL1,'Orientation','horizon');
              ah=axes('position',get(gca,'position'),...
           'visible','off');
              hAxes2=ah;
              hL2=legend(ah,[hPo,hThes],{ 'p(isPha)','isP','p(isPha,IsP)','0.5,-0.5'},'FontSize',10);
              box off
              set(hL2,'Orientation','horizon');
              set(hAxes,'Position',[0.15,0.15,0.7,0.7],'Units','normalized');
              set(ah,'Position',[0.15,0.15,0.7,0.7],'Units','normalized');
              ah1=get(hL1,'position');
              set(hL1,'Box','off');
              ah1(1:2)=[0.16,0.848-ah1(4)];
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
              figName=sprintf('/home/jiangyr/figure/phaseCmp%d.jpg',count);
              print(gcf,figName,'-djpeg','-r300');
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
           fprintf('ds = %6.2fs;dds=%4.2f;mp=%5.2f;ms=%4.2f;sPer:%5.2f%%\n',...
           ds,(dsT'*dsT/length(dsT))^0.5,mean(dpT),mean(dsT),length(dsT)/count*100); 
        end
    end
end
