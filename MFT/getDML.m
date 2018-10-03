for i=1:length(waveform)
      ml=0;mCount=0;
      for j=1:length(waveform(i).pTime)

        if sta(j).isF==0;continue;end
        if waveform(i).pTime(j)==0;continue;end
         pIndex=ceil((waveform(i).pTime(j)-waveform(i).oTime)*86400/delta+1);
         sIndex=max(ceil((waveform(i).sTime(j)-waveform(i).oTime)*86400/delta+1),pIndex+250);
         dk=distaz(sta(j).la,sta(j).lo,waveform(i).PS(2),waveform(i).PS(3));
         dk=max(10,dk);
         if sIndex-50>0 && sIndex+300<length(sta(j).data);sA=getSA(waveform(i).sta(j).waveform(sIndex+[-50:300],:))*delta;else sA=0;end
         if sA~=0 && dk >10 && dk <550;mCount=mCount+1;ml=ml+max(-1,log10(sA)+1.1*log10(dk)+0.00189*dk-2.09-0.23);end
       end
       mlN=double(ml/max(1,mCount));
       waveform(i).dml=mlN-waveform(i).PS(5);
end
