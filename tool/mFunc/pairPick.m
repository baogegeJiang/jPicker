function [oTimeLst]=pairPick(timeLst,xd,A,modP,data,bNum,delta)
min_PS=1;max_PS=30;minIsP=0;
setPicker;
oTimeCount=0;
bNumM=mod(bNum,1);
oTimeLst=zeros(300*length(timeLst),5,'double');
countLst=ceil((timeLst-bNumM*3600*24)./delta);
for i=1:length(timeLst)
    if countLst(i)<=3 ||  countLst(i)>length(data)-4;continue;end
    if (countLst(i)-50)>0&&(countLst(i)+50)<length(data) && ...
        length(find(data(countLst(i)+[-50:50],:)==0))>3;continue;end
        try
           if max(max(abs(data(countLst(i)+[-1000:-250],:))))*2.5>max(max(abs(data(countLst(i)+[-200:250],:))))...
              && isStrict>0;
                 continue;
            end
        end
	for j=i+1:length(timeLst)
        if countLst(j)<=4|| countLst(j)>length(data)-4;continue;end
        if (countLst(j)-50)>0&&(countLst(j)+50)<length(data) && ...
           length(find(data(countLst(j)+[-50:50],:)==0))>3;continue;end
		if timeLst(j)-timeLst(i)<min_PS;continue;end
		if timeLst(j)-timeLst(i)>max_PS;break;end
        if A(j)<A(i)*0.3;continue;end
        [isP,temp]=preT([xd(:,i);xd(:,j)],modP);
        if isP>minIsP;continue;end
		oTime=calOTime(timeLst(i),timeLst(j));
		oTimeCount=oTimeCount+1;
		oTimeLst(oTimeCount,:)=[oTime,timeLst(i),timeLst(j),i,j];
    end
end
oTimeLst=oTimeLst(1:oTimeCount,:);
