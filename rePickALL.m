function [dayNew] = rePickALL(day,machineIsPhase,machineIsP)
    setPath;setPara;
dayNew=day;
     loadFile;
    quake=day.quake;
    for i=1:20
        if quake(i).PS(1)~=0;break;end
    end
    tmpDay=floor(quake(i).PS(1));
    waveform=[];
    waveformMat=sprintf('%s/output/waveformMatDir/waveform%dNew.mat',workDir,tmpDay);
    waveformMatSave=sprintf('%s/output/waveformMatDir/waveform%dNewV2.mat',workDir,tmpDay);    load(waveformMat);
    for i=1:length(staLst)
        staTime(i).mat=zeros(4,0);
    end
    for i=1:length(waveform)
        if waveform(i).PS(1)==0;continue;end
        for j=1:length(staLst)
            if waveform(i).pTime(j)~=0
               staTime(j).mat(1,end+1)=waveform(i).pTime(j);
               staTime(j).mat(2,end)=i;
               staTime(j).mat(3,end)=length(find(waveform(i).pTime>0));
               staTime(j).mat(4,end)=1;
            end
            if waveform(i).sTime(j)~=0
               staTime(j).mat(1,end+1)=waveform(i).sTime(j);
               staTime(j).mat(2,end)=i;
               staTime(j).mat(3,end)=length(find(waveform(i).pTime>0));
               staTime(j).mat(4,end)=2;
            end
         end
    end
    for i=1:length(staLst)
        if size(staTime(i).mat,2)==0;continue;end
       [tmp, L]=sort(staTime(i).mat(1,:));
        
        staTime(i).mat=staTime(i).mat(:,L);
        dMat=abs(staTime(i).mat(1,2:end)-staTime(i).mat(1,1:end-1))*86400;
        for j=find(dMat<10)
            if staTime(i).mat(2,j)==staTime(i).mat(2,j+1);continue;end
            if  staTime(i).mat(3,j)> staTime(i).mat(3,j+1)
                waveform(staTime(i).mat(2,j+1)).pTime(i)=0;
                waveform(staTime(i).mat(2,j+1)).sTime(i)=0;
            else
                waveform(staTime(i).mat(2,j)).pTime(i)=0;
                waveform(staTime(i).mat(2,j)).sTime(i)=0;
            end
            fprintf('%s : %d:%s %d:%s too close\n',staLst(i).name,staTime(i).mat(2,j),datestr(staTime(i).mat(1,j)),...
            staTime(i).mat(2,j+1),datestr(staTime(i).mat(1,j+1)));
        end
     end     



  [loc res]=locQuake(waveform,2);   
   for j=1:size(loc,2)
        if loc(1,j)==0
           waveform(j).PS=waveform(j).PS*0;
           continue;
        end
        for k=1:length(waveform(j).pTime)
            if quake(j).pTime(k)==0 || waveform(j).sta(k).isF==0;
               waveform(j).pTime(k)=0;waveform(j).sTime(k)=0;
               continue;
            end
            pTime=taupnet(1,[loc(2:4,j);staLst(k).la;staLst(k).lo],1)/86400+loc(1,j);
            sTime=taupnet(1,[loc(2:4,j);staLst(k).la;staLst(k).lo],2)/86400+loc(1,j);
            pIndex0=(pTime-waveform(j).oTime)*86400/0.02;
            sIndex0=(sTime-waveform(j).oTime)*86400/0.02;
            [pIndex sIndex]=pPickerSingle(pIndex0,sIndex0,waveform(j).sta(k).waveform...
             ,[1,1,3],machineIsPhase,machineIsP); 
            waveform(j).pTime(k)=0;waveform(j).sTime(k)=0;
            if pIndex~=0;
               waveform(j).pTime(k)=pIndex*0.02/86400+waveform(j).oTime;
               if sIndex~=0
                  waveform(j).sTime(k)=sIndex*0.02/86400+waveform(j).oTime;
               end
            end
         end
     end

     [loc res]=locQuake(waveform,2);
    for j=1:size(loc,2)
         waveform(j).res=res(j);
        if loc(1,j)==0
           waveform(j).PS(1)=0;
           dayNew.quake(j).PS=waveform(j).PS*0;
           continue;
        end
        for k=1:length(waveform(j).pTime)
            if waveform(j).pTime(k)==0 || waveform(j).sta(k).isF==0;
               waveform(j).pTime(k)=0;waveform(j).sTime(k)=0;
               continue;
            end
            pTime=taupnet(1,[loc(2:4,j);staLst(k).la;staLst(k).lo],1)/86400+loc(1,j);
            sTime=taupnet(1,[loc(2:4,j);staLst(k).la;staLst(k).lo],2)/86400+loc(1,j);
            pIndex0=(pTime-waveform(j).oTime)*86400/0.02;
            sIndex0=(sTime-waveform(j).oTime)*86400/0.02;
            [pIndex sIndex]=pPickerSingle(pIndex0,sIndex0,waveform(j).sta(k).waveform...
            ,[1,1,1],machineIsPhase,machineIsP);
            waveform(j).pTime(k)=0;waveform(j).sTime(k)=0;
            if pIndex~=0;
               waveform(j).pTime(k)=pIndex*0.02/86400+waveform(j).oTime;
               if sIndex~=0
                  waveform(j).sTime(k)=sIndex*0.02/86400+waveform(j).oTime;
               end
            end
         end
         dayNew.quake(j).PS(1:4)=loc(:,j);
         dayNew.quake(j).pTime=waveform(j).pTime;
         dayNew.quake(j).sTime=waveform(j).sTime;
         
     end
     save(waveformMatSave,'waveform');
end
