setPath;
setPara;
loadFile;
plotFig=1;
delta=0.02;
loadSta;
dayS=num2str(sDay);
perCount=0;
filename=sprintf('%s/sta_%dV3.mat',matDir,sDay);
quake=day(sDay-sDay+1).quake(1:200);
%load(filename);
%loc=locQuake(quake,2);
for i=1:length(quake)
    quake0(i).pTime=quake(i).pTime;
    quake0(i).sTime=quake(i).sTime;
    quake0(i).PS=quake(i).PS;
end
 
clear resPicker
count=0;dpT=[];dsT=[];
for i=1:length(quake)
    if sum(sign(quake(i).pTime))<3;continue;end
    for j=1:length(sta)
        if quake(i).pTime(j)*quake(i).sTime(j)==0;continue;end
        count=count+1;
        fprintf('phase pair %3d_%3d: ;tPS = %5.2f s;\n',i,count,(quake(i).sTime(j)-quake(i).pTime(j))*86400)
        bNum=sta(j).bNum;
        pIndex=ceil((quake(i).pTime(j)-bNum)*86400*50);
        sIndex=ceil((quake(i).sTime(j)-bNum)*86400*50);
        if plotFig==1
           pIndex0=pIndex;
           sIndex0=sIndex;
           L=[pIndex0-300:sIndex0+700];
           clf
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
           pColor={'k','*b','+r'};
           isPlot=0;
           for cmp=1:3
               oY=3-cmp;
               hWave=plot(L/50,waveData(:,cmp)/A*0.7+oY,'b');hold on; 
               isPlot=1;
              switch cmp
              case 1
                 hPo(cmp)=plot(L/50,pData(:,cmp)*1.5+oY-3,'Color',[0.4 0.4 0.4]);
                 hThes=plot(L(1:30:end)/50,L(1:30:end)*0+0.5*0.5*1.5+oY-3,'k');
              case 2
                   [tmp pL]=getdetec(pData(:,1),0.25,30);
                   hPo(cmp)=plot(pL/50+L(1)/50-1/50,pL*0+oY-2.5,pColor{cmp},'markersize',7); 
                   pIndexSi=pL(1)+L(1)-1;
               case 3
                   xdP=conXD(pIndexSi,sta(j).data);
                   xdF=conXD(pL+L(1)-1,sta(j).data);
                   xdSi=[xdP+xdF*0;xdF];
                   isP=preT(xdSi,machineIsP);
                   phaseL=pL+L(1)-1;
                   sL=phaseL(find(isP<0));
                   if length(sL)>0
                   sIndexSi=sL(1);
               %    hPo(cmp)=plot(sL/50,sL*0+oY-2,pColor{cmp});
                   plot(pIndexSi/50,oY-1,'*b','markersize',7);
%                   plot(sIndexSi/50,oY-1,'+r');
                   end
                end
           end
           if isPlot==1
              title(sprintf('quake:%d phase pair: %d',i,count),'FontSize',12); 
              box on
              X0=L([1,end-20])/50;Y0=[-2.5,2.8];
              xlim(X0);
              ylim(Y0);
              xlabel('time/s','FontSize',10);
              ylabel('component','FontSize',10);
              set(gca,'ytick',[-2,-1.5,-1,-1+1.5/4,0,1,2]);
              set(gca,'yticklabel',{'S','Phases','p(w^T*x+b)','0.5','BHZ','BHN','BHE'},'FontSize',10);
              figName=sprintf('%s/output/figure/phaseCmpP%d.pdf',workDir,count);
               ylim([-2.0,2.8]);
              print(gcf,figName,'-djpeg','-r300');
              hPo(cmp)=plot(sL/50,sL*0+oY-2,pColor{cmp},'markersize',7);
%              plot(pIndexSi/50,oY-1,'ob');
              plot(sIndexSi/50,oY-1,'+r','markersize',7);
              ylim(Y0);
%              figName=sprintf('/home/jiangyr/figureAGU/phaseCmp%d.jpg',count);
%              print(gcf,figName,'-djpeg','-r300');
               saveas(gcf,figName)  
         end
        end
    end
end
