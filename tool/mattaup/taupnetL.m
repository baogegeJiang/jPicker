function [time,G]=taupnetL(~,infoL,phaseClassL)
time=zeros(length(phaseClassL),1);
G=zeros(3,length(phaseClassL));

global taupMatPG taupMatSG
if ~isempty(taupMatPG) && ~isempty(taupMatSG)
  maxPDeg=size(taupMatPG,1);maxSDeg=size(taupMatSG,1);
  maxPDep=size(taupMatPG,2);maxSDep=size(taupMatSG,2);
end
for i=1:length(phaseClassL)
    info=infoL(:,i);phaseClass=phaseClassL(i);
    [~, deg, angle, ~]=distaz(info(1),info(2),info(4),info(5));
    [~, deg1, angle1, ~]=distaz(info(1)+0.005,info(2),info(4),info(5));
    dLa=(deg1-deg)/0.005;
    [~, deg1, angle1, ~]=distaz(info(1),info(2)+0.005,info(4),info(5));
    dLo=(deg1-deg)/0.005;
    dep=max(1,info(3));
    depN=max(1,round(dep));
    degN=max(1,round(deg/0.005)+1);
   if  phaseClass==1 && depN<=maxPDep-1 &&degN<=maxPDeg-1
       time(i)=taupMatPG(degN,depN);
       timeDeg=taupMatPG(degN+1,depN);
       timeDep=taupMatPG(degN,depN+1);
       degG=(timeDeg-time(i))/0.005;
       depG=(timeDep-time(i));
       G(:,i)=[degG*dLa;degG*dLo;depG];
       continue;
   end
   if  phaseClass==2 && depN<=maxSDep-1 &&degN<=maxSDeg-1
       time(i)=taupMatSG(degN,depN);
       timeDeg=taupMatSG(degN+1,depN);
       timeDep=taupMatSG(degN,depN+1);
       degG=(timeDeg-time(i))/0.005;
       depG=(timeDep-time(i));
       G(:,i)=[degG*dLa;degG*dLo;depG];
       continue;
   end    
end
% call tauptimeJ function to calculate the travel time
% in former version, we have used net to accelerate our calculation. but now, we don't do this. however, we remain this format for convenience. you can assign any value to net.

end

