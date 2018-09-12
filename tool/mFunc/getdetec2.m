function [ c,t ] = getdetec2( DATA,cc_min,d_min )
l=length(DATA);count=0;c=-1;t=-1;DIF=0;
maxDif=0.2;
for i=1:l
    if DATA(i)<=cc_min
       %DIF=1; 
       continue
    end
    if count~=0;
    if DATA(i)<= c(count)-maxDif && c(count)>0
    DIF=1;
    end
    end
    %count=count+1;
    if count == 0
        count=count+1;
        c(count)=DATA(i);
        t(count)=i;
        DIF=0;
        continue;
    end
    if i>t(count)+d_min || DIF==1
        count=count+1;
        c(count)=DATA(i);
        t(count)=i;
        DIF=0;
        continue;
    end
    if DATA(i)>c(count)
        c(count)=DATA(i);
        t(count)=i;
        DIF=0;
    end
end

