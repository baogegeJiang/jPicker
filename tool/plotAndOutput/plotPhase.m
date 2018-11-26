setPath;
setPara;
delta=0.02;
figureDir=[workDir,'output/figure/'];
if exist(figureDir,'file');
   rmdir(figureDir,'s');
end
mkdir(figureDir);
for dayIndex=1:length(day)
quake=day(dayIndex).quake;
tmpDay=dayIndex+sDay-1;
tmpDay0=tmpDay-refDay+1;
filename=sprintf('%ssta_%dV3.mat',matDir,tmpDay);
if exist(filename,'file')
load(filename);
else
continue;
end
for i=1:length(quake)
   
    if sum(sign(quake(i).pTime))<3;continue;end
    for j=1:length(quake(i).pTime)
        clf
        figure(1); hold on
        if quake(i).pTime(j)==0;continue;end
        pIndex=ceil((quake(i).pTime(j)-sta(j).bNum)*86400/delta);
        sIndex=ceil((quake(i).sTime(j)-sta(j).bNum)*86400/delta);
        bIndex=pIndex-500;
        eIndex=max(sIndex,pIndex+500)+500;
        L=bIndex:eIndex;
        if 0;
        xdL=conXD([pIndex L],sta(j).data);
        pXD=xdL(:,1);
        xdL=[xdL(:,2:end)*0+pXD;xdL(:,2:end)];
        isP=preT(xdL,machineIsP);
        plot(L*delta,isP/max(abs(isP)),'g');
        plot(L*delta,L*0,'g');
        end
        A=max(max(abs(sta(j).data(L,:))));
        for k=1:3
            Pos=3-k;
            plot(L*delta,0.5*sta(j).data(L,k)/A+Pos,'color',[0.5 0.5 0.5]);
        end
        plot(pIndex*delta+[0,0],[-0.5 2.5],'.-b');
        plot(sIndex*delta+[0,0],[-0.5 2.5],'.-r');
%        isP=preT(xdL,machineIsP);
%        plot(L*delta,isP/max(abs(isP)),'g');
%        plot(L*delta,L*0,'g');
        ylim([-0.6,2.6]);
        xlim(L([1,end])*delta);
        set(gca,'ytick',[0,1,2]);
        set(gca,'yticklabel',{'BHZ','BHN','BHE'});
        title(sprintf('day:%d quake:%d sta: %s',tmpDay,i,staLst(j).name));
        fprintf('day:%d quake:%d sta: %s\n',tmpDay,i,staLst(j).name);
        figName=sprintf('%dquake%d_%s.jpg',tmpDay,i,staLst(j).name);
        print(gcf,[figureDir,figName],'-djpeg','-r300');
    end
end
end
