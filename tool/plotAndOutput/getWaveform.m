function [ tmp]=getWaveform(sta,quake)
setPath;
tmpDay=floor(quake(2).PS(1));
waveformMat=sprintf('%s/output/waveformMatDir/waveform%d_100.mat',workDir,tmpDay);
delta=0.02;
for i=1:length(sta)
    if sta(i).isF==1
       delta=sta(i).delta;
       break;
    end
end
[loc,res]=locQuake(quake,2);
for i=1:length(quake)
    waveform(i).PS=quake(i).PS;
    waveform(i).pTime=quake(i).pTime;
    waveform(i).sTime=quake(i).sTime;
    waveform(i).oTime=quake(i).PS(1)-100/86400;
    waveform(i).eTime=quake(i).PS(1)+150/86400;
    oTime=quake(i).PS(1)-100/86400;
    eTime=quake(i).PS(1)+150/86400;
    waveform(i).res=res(i);
    for j=1:length(sta)
        waveform(i).sta(j).isF=0;
        if sta(j).isF==0||quake(i).pTime(j)==0;continue;end
        bIndex=floor((oTime-sta(j).bNum)*86400/delta);
        eIndex=floor((eTime-sta(j).bNum)*86400/delta);
        if  bIndex>0&& eIndex<=length(sta(j).data);
            waveform(i).sta(j).isF=1;
            waveform(i).sta(j).waveform=sta(j).data(bIndex:eIndex,:);
            waveform(i).sta(j).delta=sta(j).delta;
       end
     end
end
save(waveformMat,'waveform');
        
