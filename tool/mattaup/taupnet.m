function [time]=taupnet(net,info,phaseClass)

global taupMatPG taupMatSG
if length(taupMatPG)~=0 && length(taupMatSG)~=0
   maxPDeg=size(taupMatPG,1);maxSDeg=size(taupMatSG,1);
   maxPDep=size(taupMatPG,2);maxSDep=size(taupMatSG,2);
   [a deg c d]=distaz(info(1),info(2),info(4),info(5));
   dep=max(1,info(3));
   depN=max(1,round(dep));
   degN=max(1,round(deg/0.005)+1);
   if  phaseClass==1 && depN<=maxPDep &&degN<=maxPDeg
       time=taupMatPG(degN,depN);
       return;
   end
   if  phaseClass==2 && depN<=maxSDep &&degN<=maxSDeg
       time=taupMatSG(degN,depN);
        return;
    end
       
end
% call tauptimeJ function to calculate the travel time
% in former version, we have used net to accelerate our calculation. but now, we don't do this. however, we remain this format for convenience. you can assign ang value to net.
if phaseClass==1
   temp=tauptimeJ('mod','iasp91','dep',max(0.5,info(3)),'ph','p,P,Pn',...
   'sta',[info(4), info(5)],'evt',[info(1),info(2)]);  
   time=temp(1).time;
else 
    temp=tauptimeJ('mod','iasp91','dep',max(0.5,info(3)),'ph','s,S,Sn',...
    'sta',[info(4), info(5)],'evt',[info(1),info(2)]);
    time=temp(1).time;
end
end
