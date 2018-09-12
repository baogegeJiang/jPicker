function [la,lo]= getSta(net,sta,staLst)
name=[net,'.',sta];
for i=1:length(staLst)
if strcmp(name,staLst(i).name);
la=staLst(i).la;
lo=staLst(i).lo;
break;
end
end
