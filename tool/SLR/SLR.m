function [res ]=STR(x)
mexSLR=1;
setPara;
if mexSLR==1;
res=single(SLRC(double(x),length(x))');
return
end
C1=0.5;C2=0.1;C3=0.1;C4=0.01;
alpha=0;beta=0;res=x;R=0;dR=0;F=0;E=0;res(1)=0;

for i=2:length(x)

R=C1*R+x(i)-x(max(1,i-1));
dR=C2*(x(i)-x(max(1,i-1)));
E=R^2+dR^2;
alpha=alpha+C3*(E-alpha);
beta=beta+C4*(E-beta);

if beta==0
	res(i)=0;
else
	res(i)=alpha/beta;
end

end
res=res';
end
