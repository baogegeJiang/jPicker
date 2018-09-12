function [ c,t ] = getdetec( DATA,cc_min,d_min )
l=length(DATA);count=0;c=-1;t=-1;
for i=1:l
    if DATA(i)<=cc_min
        continue
    end
    %count=count+1;
    if count == 0
        count=count+1;
        c(count)=DATA(i);
        t(count)=i;
        continue;
    end
    if i>t(count)+d_min
        count=count+1;
        c(count)=DATA(i);
        t(count)=i;
        continue;
    end
    if DATA(i)>c(count)
        c(count)=DATA(i);
        t(count)=i;
    end
end

