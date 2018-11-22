function [oTime]=calOTime(pTime,sTime)
        dTime=sTime-pTime;
	%if abs(sTime-pTime)<0.001;b=(-0.9636)/86400;else;b=-0.9636;end
        global oTimeMatG
        if length(oTimeMatG)~=0
           if abs(dTime)<0.001;
              % 1
              oTime=pTime-interp1(oTimeMatG(:,1),oTimeMatG(:,2),dTime*86400)/86400;
           else
              oTime=pTime-interp1(oTimeMatG(:,1),oTimeMatG(:,2),dTime);
           end
           if isnan(oTime)==0
%              fprintf('*** in oTimeMat ***');
              return
           else
              1;%fprintf('not in oTimeMat');
           end
        end
        k=1.726;k1=-0.5756;k2=-0.1245;
        if abs(dTime)<0.001;
	oTime=pTime-...
                   (....
                    dTime/(k-1)...
                    +heaviside(dTime-19.14/86400)*heaviside(20.94/86400-dTime)*(dTime-19.14/86400)*k1...
                    +heaviside(dTime-20.94/86400)*(dTime-12.6027/86400)*k2 ...
                );
        else
                oTime=pTime-...
                   (....
                    dTime/(k-1)...
                    +heaviside(dTime-19.14)*heaviside(20.94-dTime)*(dTime-19.14)*k1...
                    +heaviside(dTime-20.94)*(dTime-12.6027)*k2 ...
                );
       end  
%(1.74-1);%*1.5;
        
end
%1.683
%1.750
%1.8006
%1.74
