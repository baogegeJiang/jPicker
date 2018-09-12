function [T ] = tauptimels( phase,ela,elo,sla,slo,d,H )
[dk,dd,ee,bb]=distaz(sla,slo,ela,elo);
p1=3.5;p2=6;p3=7.5;
s1=2;s2=3.45;s3=4.1;
syms p;
switch phase
    case 'Pg'
        if d<=10
            T=(dk^2+(d+H)^2)^0.5/p1;
        elseif d<=30
           pp=fzero(@(p) (d-10)*p/(1/p2^2-p^2)^0.5+(10+H)*p/(1/p1^2-p^2)^0.5-dk,[0,1/p2-0.00001]);
           T=dk*pp+(d-10)*(1/p2^2-pp^2)^0.5+(10+H)*(1/p1^2-pp^2)^0.5;
        else
           pp=fzero(@(p) (d-30)*p/(1/p3^2-p^2)^0.5+20*p/(1/p2^2-p^2)^0.5+(10+H)*p/(1/p1^2-p^2)^0.5-dk ,[0,1/p3-0.00001]);
           T=dk*pp+(d-30)*(1/p3^2-pp^2)^0.5+20*(1/p2^2-pp^2)^0.5+(10+H)*(1/p1^2-pp^2)^0.5;
        end
    case 'Sg'
        p1=s1;p2=s2;p3=s3;
           if d<=10
            T=(dk^2+(d+H)^2)^0.5/p1;
        elseif d<=30
           pp=fzero(@(p) (d-10)*p/(1/p2^2-p^2)^0.5+(10+H)*p/(1/p1^2-p^2)^0.5-dk,[0,1/p2-0.00001]);
           T=dk*pp+(d-10)*(1/p2^2-pp^2)^0.5+(10+H)*(1/p1^2-pp^2)^0.5;
        else
           pp=fzero(@(p) (d-30)*p/(1/p3^2-p^2)^0.5+20*p/(1/p2^2-p^2)^0.5+(10+H)*p/(1/p1^2-p^2)^0.5-dk ,[0,1/p3-0.00001]);
           T=dk*pp+(d-30)*(1/p3^2-pp^2)^0.5+20*(1/p2^2-pp^2)^0.5+(10+H)*(1/p1^2-pp^2)^0.5;
        end
    case 'Pn'
        pp=1/p3;
        if d <=10
            dn=(H+10+10-d)*pp/(1/p1^2-pp^2)^0.5+40*pp/(1/p2^2-pp^2)^0.5;
            if dk<dn
                T=-1;
            else
                T=dk*pp+(H+10+10-d)*(1/p1^2-pp^2)^0.5+40*(1/p2^2-pp^2)^0.5;
            end
        elseif d<=30
            dn=(H+10)*pp/(1/p1^2-pp^2)^0.5+(40-d+10)*pp/(1/p2^2-pp^2)^0.5;
            if dk<dn
                T=-1;
            else
                T=dk*pp+(H+10)*(1/p1^2-pp^2)^0.5+(50-d)*(1/p2^2-pp^2)^0.5;
            end
        else
            T=-1;
        end
        case 'Sn'
        pp=1/s3;p1=s1;p2=s2;p3=s3;
        if d <=10
            dn=(H+10+10-d)*pp/(1/p1^2-pp^2)^0.5+40*pp/(1/p2^2-pp^2)^0.5;
            if dk<dn
                T=-1;
            else
                T=dk*pp+(H+10+10-d)*(1/p1^2-pp^2)^0.5+40*(1/p2^2-pp^2)^0.5;
            end
        elseif d<=30
            dn=(H+10)*pp/(1/p1^2-pp^2)^0.5+(40-d+10)*pp/(1/p2^2-pp^2)^0.5;
            if dk<dn
                T=-1;
            else
                T=dk*pp+(H+10)*(1/p1^2-pp^2)^0.5+(50-d)*(1/p2^2-pp^2)^0.5;
            end
        else
            T=-1;
        end
            
end

