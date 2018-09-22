function [ l,clock1 ] = processDis( str1,per,c1,len,c2,str2,L,clock0)
% str1 per*100% c1 c2 c2 ------- c1 str2
% L is the last display line's length
% clock0 is the last display time
% if the passing time is shorter than dtimeMin, the function would not display
dtimeMin=0.5;
if strcmp(c1,c2)==1;c2='*';end
clock1=clock;
dtime=etime(clock1,clock0);
if dtime <dtimeMin && per<0.99
    l=L;clock1=clock0;
    return;
end
strPer=sprintf('%3d%%',round(per*100));
N=min(len,max(0,round(per*len)));
strC2=[repmat(c2,1,N),repmat(' ',1,(len-N)*length(c2))];
str=sprintf('%s %s %s %s %s %s',str1,strPer,c1,strC2,c1,str2);
if L~=0
    strB=repmat('\b',1,L);
    fprintf(strB);
end
fprintf('%s %s %s %s %s %s',str1,strPer,c1,strC2,c1,str2);
l=length(str);
if per==1;
    fprintf('\n');
end
end

