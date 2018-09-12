load tmpQuake;
setPara;
setPath;
waveformDir=[workDir,'/output/waveformMatDir/'];
dayNum0=0;
count=0;
clear tmpWaveform
for i=1:length(tmpQuake)
    i
    dayNum=floor(tmpQuake(i).PS(1));
    if dayNum~=dayNum0;
       waveformFile=sprintf('%s/waveform%d_100.mat',waveformDir,dayNum)
       if exist(waveformFile,'file')
          load(waveformFile);
          dayNum0=dayNum;
       else
          continue;
       end
    end
    quakeIndex=tmpQuake(i).index;
    count=count+1;
    tmpWaveform(count)=waveform(quakeIndex);
end 
save MFT/tmpWaveform tmpWaveform
