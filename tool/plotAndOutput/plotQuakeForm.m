for i=12%:length(waveform)
    figure(1);clf;hold on
    pTime=waveform(i).pTime;
    isL=find(pTime>0);
    maxTime=max(pTime(isL))+50/86400;
    minTime=min(pTime(isL))-10/86400;
    [tmp L]=sort(pTime(isL));
    L=isL(L);
    A=5;
    for j=1:length(L)
        index=L(j);
        j=(pTime(index)-waveform(i).PS(1))*86400;
        if waveform(i).sta(index).isF==0||waveform(i).pTime(index)==0;continue;end
        waveTmp=waveform(i).sta(index).waveform(:,1);
        waveTmp=waveTmp/max(waveTmp)*A;
        plot((waveform(i).oTime-waveform(i).PS(1))*86400+[1:length(waveTmp)]*0.02,waveTmp+j,'k');
        plot((pTime(index)-waveform(i).PS(1))*86400+[0 0],j+[-0.7 0.7]*A,'-b');
        if waveform(i).sTime(index)~=0
            plot((waveform(i).sTime(index)-waveform(i).PS(1))*86400+[0 0],j+[-0.7 0.7]*A,'-r');
        end
    end
    xlim(([minTime maxTime]-waveform(i).PS(1))*86400);
end
