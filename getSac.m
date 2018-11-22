seedDir='/media/geodyn/NMDATA/20142015/';
clear dir
tmpSeed='/home/jiangyr/tmpSeed/';
sacDir='/home/jiangyr/sacData/';
dayDir='/home/jiangyr/sacDir/';
mergeExe='/home/jiangyr/sacmerge';

for dayNum=sDay:eDay
    fprintf('%s: ',datestr(dayNum));
    if dayNum<datenum(2015,1,1)+84;continue;end
    for hour=0:23
       fprintf('%d ',hour)
       dateStr=datestr(dayNum,30);
       seedFile1=sprintf('%s/%s%02d.NM.seed',seedDir,dateStr(1:8),hour);
       seedFile2=sprintf('%s/%s%02d.NM.seed',tmpSeed,dateStr(1:8),hour);
       unix(sprintf('cp %s %s',seedFile1,seedFile2));
       unix(sprintf('rdseed -d -f %s -o 1 -q %s > seedLog 2>&1',seedFile2,tmpSeed));
       YM=datestr(dayNum+(hour-8)/24,30);YM=YM(1:6);
       for k=102:length(staLst)
            YMDir=sprintf('%s/%s.%s/%s/',sacDir,staLst(k).net,staLst(k).station,YM);
           if exist(YMDir)==0
              mkdir(YMDir);
           end
           unix(sprintf('cp  %s/*%s*%s*.SAC %s > cpLog 2>&1' ,tmpSeed,staLst(k).net,...
           staLst(k).station,YMDir));
       end
       unix(sprintf('rm -r %s/',tmpSeed)); 
       mkdir(tmpSeed); 
%       fprintf('\n');   
    end
    fprintf('\n');  
end

%unix([mergeExe,' -o ',outputFile,' ',bStr,' ',eStr,' ',tmpDir,'*',cmpStr(k),'.?.SAC > /dev/null']);
for dayNum=sDay:eDay
    fprintf('%s: ',datestr(dayNum));
    if dayNum<datenum(2015,1,1)+84;continue;end
    for hour=0
       fprintf('%d ',hour)
       dateStr=datestr(dayNum,30);
       YM=datestr(dayNum,30);YMD=YM(1:8);YM=YM(1:6);
       sDay0=datenum(str2num(YM(1:4)),1,1);
       dayS=sprintf('%03d',datenum(str2num(YM(1:4)),str2num(YM(5:6)),str2num(YMD(7:8)))-sDay0+1);
       dayS0=sprintf('%03d',datenum(str2num(YM(1:4)),str2num(YM(5:6)),str2num(YMD(7:8)))-sDay0);
       for k=102:length(staLst)
            YMDir1=sprintf('%s/%s.%s/%s/',sacDir,staLst(k).net,staLst(k).station,YM);
            YMDir2=sprintf('%s/%s.%s/%s/',dayDir,staLst(k).net,staLst(k).station,YM);
           if exist(YMDir2)==0
              mkdir(YMDir2);
           end

           outputFile=sprintf('%s/%s.%s.%s.%sE.SAC',YMDir2,staLst(k).net,staLst(k).station,YMD,staLst(k).comp);
           bStr=[YMD,'-000001'];
           eStr=[YMD,'-235959'];
           inputFile1=sprintf('%s/%s.%s*%s.%s.00.*%sE.D.SAC',YMDir1,YM(1:4),dayS,staLst(k).net,staLst(k).station,staLst(k).comp);
           inputFile2=sprintf('%s/%s.%s*%s.%s.00.*%sE.D.SAC',YMDir1,YM(1:4),dayS0,staLst(k).net,staLst(k).station,staLst(k).comp); 
           tmp=dir(inputFile1);
           if length(tmp)==0;
              fprintf('no %s \n',inputFile1);
              continue;end
           tmp=dir(inputFile2);
           if length(tmp)==0;
              fprintf('no %s \n',inputFile2);                                                                               
              inputFile2=' ';;end
           unix([mergeExe,' -o ',outputFile,' ',bStr,' ',eStr,' ',inputFile1,' ',inputFile2,'  > /dev/null']);

           outputFile=sprintf('%s/%s.%s.%s.%sN.SAC',YMDir2,staLst(k).net,staLst(k).station,YMD,staLst(k).comp);             
           bStr=[YMD,'-000001'];                                                                                            
           eStr=[YMD,'-235959'];
           inputFile1=sprintf('%s/%s.%s*%s.%s.00.*%sN.D.SAC',YMDir1,YM(1:4),dayS,staLst(k).net,staLst(k).station,staLst(k).comp);
           inputFile2=sprintf('%s/%s.%s*%s.%s.00.*%sN.D.SAC',YMDir1,YM(1:4),dayS0,staLst(k).net,staLst(k).station,staLst(k).comp);
           tmp=dir(inputFile1);                                                                                             
           if length(tmp)==0;
              fprintf('no %s \n',inputFile1);                                                                               
              continue;end                                                                                                  
           tmp=dir(inputFile2);
           if length(tmp)==0;
              fprintf('no %s \n',inputFile2);
              inputFile2=' ';;end
           unix([mergeExe,' -o ',outputFile,' ',bStr,' ',eStr,' ',inputFile1,' ',inputFile2,'  > /dev/null']);

           outputFile=sprintf('%s/%s.%s.%s.%sZ.SAC',YMDir2,staLst(k).net,staLst(k).station,YMD,staLst(k).comp);             
           bStr=[YMD,'-000001'];                                                                                            
           eStr=[YMD,'-235959'];
           inputFile1=sprintf('%s/%s.%s*%s.%s.00.*%sZ.D.SAC',YMDir1,YM(1:4),dayS,staLst(k).net,staLst(k).station,staLst(k).comp);
           inputFile2=sprintf('%s/%s.%s*%s.%s.00.*%sZ.D.SAC',YMDir1,YM(1:4),dayS0,staLst(k).net,staLst(k).station,staLst(k).comp);
           tmp=dir(inputFile1);                                                                                             
           if length(tmp)==0;
              fprintf('no %s \n',inputFile1);                                                                               
              continue;end                                                                                                  
           tmp=dir(inputFile2);
           if length(tmp)==0;
              fprintf('no %s \n',inputFile2);
              inputFile2=' ';;end
           unix([mergeExe,' -o ',outputFile,' ',bStr,' ',eStr,' ',inputFile1,' ',inputFile2,'  > /dev/null']);
       end
%       fprintf('\n');   
    end
    fprintf('\n');  
end



