setPath;
phaseFile=[workDir,'/output/phaseLstALL'];
dH=8/24;
phaseF={};
phaseCount=0;
for i=1:length(dayPhase)
    for j=1:length(dayPhase(i).sta)
        for k=1:dayPhase(i).sta(j,1).timeCount
         tempTime=dayPhase(i).sta(j,1).time(k)+dH;
         tempStr=datestr(tempTime,30);
         timeStr=[tempStr(1:8),tempStr(10:15)];
         msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));                    
         timeStr=[timeStr,'.',msecStr];
         temp=cutby(staLst(j).name,'.');
         %staName=temp{2};
         staName=staLst(j).name;
         phaseStr=[staLst(j).net,'.',staName,',',timeStr,',','P'];
         phaseCount=phaseCount+1; 
         phaseF{phaseCount,1}=phaseStr; 
         end
         for k=1:dayPhase(i).sta(j,2).timeCount                                            
         tempTime=dayPhase(i).sta(j,2).time(k)+dH;                                            
         tempStr=datestr(tempTime,30);                                                    
         timeStr=[tempStr(1:8),tempStr(10:15)];                                           
         msecStr=sprintf('%02d',mod(floor(tempTime*24*3600*100),100));                    
         timeStr=[timeStr,'.',msecStr];                                                   
         temp=cutby(staLst(j).name,'.');                                                  
         %staName=temp{2};                                                                
         staName=staLst(j).name;                                                          
         phaseStr=[staLst(j).net,'.',staName,',',timeStr,',','S'];                        
         phaseCount=phaseCount+1;                                                         
         phaseF{phaseCount,1}=phaseStr;                                                   
         end
     end
end
wfile(phaseF,phaseFile);
