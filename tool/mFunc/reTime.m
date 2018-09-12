function [quake]=reTime(quake,i)
global velNG
velNG=mod(i,12)+1;
loc=locQuake(quake,1.5);
for j=1:length(quake) 
 quake(j).PS(1:4)=loc(1:4,j)';   
end 
i
end
