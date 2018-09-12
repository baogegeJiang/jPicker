function[dayPhase]=readPhase(filePath,sDay)
    line=textread(filePath,'%s','delimiter','\n','whitespace','');
    for i=1:length(line)
        temp=cutby(line{i},',');
        temp2=cutby(temp{1},' '); 
        temp{1}=temp2{1};
        phaseCell(i,1:length(temp))=temp;
    end
    loadSta;
    maxDayCount=0;
    for i=1:length(phaseCell)
        staName=phaseCell{i,1};
       % if strcmp(staName(1),'2');break;end
        jj=-100;
        for j=1:length(staLst)
            if strcmp(staName,[staLst(j).net,'.',staLst(j).station])||strcmp(staName,staLst(j).name)
               jj=1; 
               break
            end
            %jj=-100;
        end
        if jj==-100;continue;end
        staIndex=j;
        dateStr=phaseCell{i,2};
        dayNum=datenum(str2num(dateStr(1:4)),str2num(dateStr(5:6)),str2num(dateStr(7:8)),str2num(dateStr(9:10)),str2num(dateStr(11:12)),...
        str2num(dateStr(13:end)))-8/24;
        if strcmp(phaseCell{i,3},'P');phaseType=1;else;phaseType=2;end
        dayCount=ceil(dayNum)-sDay;
        if dayCount<=0;continue;end
        if dayCount>maxDayCount
           for k=1:length(staLst)
           dayPhase(dayCount).sta(k,1).timeCount=0;
           dayPhase(dayCount).sta(k,2).timeCount=0;
           end
           maxDayCount=dayCount;
        end
        dayPhase(dayCount).sta(j,phaseType).timeCount=dayPhase(dayCount).sta(j,phaseType).timeCount+1;
        dayPhase(dayCount).sta(j,phaseType).time(dayPhase(dayCount).sta(j,phaseType).timeCount)=dayNum;
    end
for i=1:length(dayPhase)
    for j=1:length(dayPhase(i).sta)
        if dayPhase(i).sta(j,1).timeCount>0
           dayPhase(i).sta(j,1).time=sort(dayPhase(i).sta(j,1).time);
        end
        if dayPhase(i).sta(j,2).timeCount>0
           dayPhase(i).sta(j,2).time=sort(dayPhase(i).sta(j,2).time);
        end
    end
end
end
