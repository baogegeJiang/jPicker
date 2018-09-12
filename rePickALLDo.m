for i=1:12:length(day)
    fprintf('*******************%d************************\n',i);
    parfor ii=i:min(i+11,length(day))
           dayNew(ii)=rePickALL(day(ii),machineIsPhase,machineIsP)
   end
end
