function [a,b]=getTime(dep,deg)
temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','p,P,Pn');
a=temp(1).time;
temp=tauptimeJ('mod','iasp91','dep',dep,'deg',deg,'ph','s,S,Sn');
b=temp(1).time;
end