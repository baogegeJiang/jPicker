setMFT
load waveformTmp20180917

%for i=1:length(tmpWaveform)
%    for j=1:length(tmpWaveform(i).pTime)
%        if tmpWaveform(i).pTime(j)>0 && tmpWaveform(i).sta(j).isF>0
%           for k=1:3 
%               waveform(i).sta(j).waveform(:,k)=single(filter_fcn( double(waveform ...
%(i).sta(j).waveform(:,k)),sta(j).delta,mode,order,f,nodelay ));
%           end
%        end
%     end
%end
for dayNum=sDayMFT:eDayMFT
    if dayNum<datenum(2014,10,11);continue;end
    tmp= dayMFT(dayNum,tmpWaveform);
    waveformDet(dayNum-sDayMFT+1).isF=0;
    if length(tmp)~=0;
       waveformDet(dayNum-sDayMFT+1).isF=1;
       waveformDet(dayNum-sDayMFT+1).det=tmp;
    end
end
