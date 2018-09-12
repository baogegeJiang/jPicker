function [result ]=calXD(v)
%result.vec=[(v(1:3).^0.5).*sign([1;v(4);v(5)])];
L=[1,4,5;4,2,6;5,6,3];
%[vMax,indexTemp]=max(v(1:3));
%for i=1:3
%result.vec(i,1)=v(i)^0.5*sign(v(L(i,indexTemp)));
%end
L=L;
[a,b]=eig(v(L));
[bMax,bIndex]=max([b(1,1),b(2,2),b(3,3)]);
result.vec=sign(bMax)*a(:,bIndex);
%result.vec=[v(1);v(4);v(5)]/norm([v(1);v(4);v(5)]);
result.phase=[v(4:6)./([v(1)*v(2);v(1)*v(3);v(2)*v(3)].^0.5)];
result.S=v(L);
result.eigV=-sort(-([b(1,1),b(2,2),b(3,3)]));
result.F2=((result.eigV(1)-result.eigV(2))^2+(result.eigV(1)-result.eigV(3))^2+(result.eigV(3)-result.eigV(2))^2)/(sum(result.eigV)^2);
