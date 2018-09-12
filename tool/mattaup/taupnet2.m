function [time]=taupnet(net,info,phaseClass)
if 0%info(3)>0 && info(3)<50
   time=sim(net,[distaz(info(3),info(4),info(1),info(2));info(5)]);
   if 0%phaseClass==1 && time<35;
      return;
   end
   if phaseClass==2 && time<60;
      return
   end
end
%else
     if phaseClass==1
        temp=tauptime('mod','iasp91','dep',max(0.5,info(3)),'ph','p,P,Pn',...
        'sta',[info(4), info(5)],'evt',[info(1),info(2)]);  
        time=temp(1).time;
     else
%       temp=tauptimeJ('mod','iasp91','dep',max(0.5,info(3)),'ph','p,P,Pn',...
%        'sta',[info(4), info(5)],'evt',[info(1),info(2)]);
%        time=temp(1).time*1.683+0.005246; 
       temp=tauptime('mod','iasp91','dep',max(0.5,info(3)),'ph','s,S,Sn',...
       'sta',[info(4), info(5)],'evt',[info(1),info(2)]);
        time=temp(1).time;
     end
%end
end
