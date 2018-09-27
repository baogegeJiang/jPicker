delta=0.01;
fl=0.5;fh=15;
setMFT;
f=[fl,fh];
for i=1:length(tmpWaveform)
i
    for j=1:length(tmpWaveform(i).pTime)
       if tmpWaveform(i).pTime(j)==0;continue;end
          for k=1:3
              tmpWaveform(i).sta(j).waveform(:,k)=single(filter_fcn( double( tmpWaveform(i).sta(j).waveform(:,k)),delta,mode,order,f,nodelay ));
          end
    end
end
file=sprintf('MFT/tmpWave_%.1f_%d.mat',fl,fh);
save(file,'tmpWaveform');
