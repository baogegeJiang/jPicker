function [F]=calF(D0)
for i=1:size(D0,2)
D=D0(:,i);
mid=size(D,1)/2;
temp1=calXD(D(1:6));
temp2=calXD(D([1:6]+mid));
F1=acos(abs(temp1.vec'*temp2.vec))/(pi/2);
F2=temp2.F2;
F3=1-temp1.vec'*temp2.S*temp1.vec;
F(i,1)=F1*F2*F3;
end
end
