function[xd]= conVector(index,data)
xd=zeros(24,1,'double');
if length(index)==0;xd=zeros(24,1,'double');return;end
windowLength1=75;%30
index0=index;
l=size(data,1);
for i=1:length(index)
index=index0(i);
if index<=0 || index+windowLength1>l;xd(:,i)=zeros(24,1);continue;end
x1=data(index:index+windowLength1,1);
x11=data(index:index+windowLength1,2);
x111=data(index:index+windowLength1,3);
dx1=x1(2:end)-x1(1:end-1);
dx11=x11(2:end)-x11(1:end-1);
dx111=x111(2:end)-x111(1:end-1);
%ddx1=(x1(5:end)+x1(4:end-1)-x1(2:end-3)-x1(1:end-4))/6;
%ddx11=(x11(5:end)+x11(4:end-1)-x11(2:end-3)-x11(1:end-4))/6;
%ddx111=(x111(5:end)+x11(4:end-1)-x11(2:end-3)-x111(1:end-4))/6;
%w1=1/4*(x1(1:end-3)+x1(2:end-2)+x1(3:end-1)+x1(4:end));
%w11=1/4*(x11(1:end-3)+x11(2:end-2)+x11(3:end-1)+x11(4:end));
%w111=1/4*(x11(1:end-3)+x111(2:end-2)+x111(3:end-1)+x111(4:end));
w1=smooth(x1,'lowess');
w11=smooth(x11,'lowess');
w111=smooth(x111,'lowess');
dw1=w1(2:end)-w1(1:end-1);
dw11=w11(2:end)-w11(1:end-1);
dw111=w111(2:end)-w111(1:end-1);
%temp=[x1'*x1;x11'*x11;x111'*x111;x1'*x11;x1'*x111;x11'*x111;dx1'*dx1;dx11'*dx11;dx111'*dx111;dx1'*dx11;dx1'*dx111;dx11'*dx111;];
temp=[x1'*x1;x11'*x11;x111'*x111;x1'*x11;x1'*x111;x11'*x111;dx1'*dx1;dx11'*dx11;dx111'*dx111;dx1'*dx11;dx1'*dx111;dx11'*dx111;...
w1'*w1;w11'*w11;w111'*w111;w1'*w11;w1'*w111;w11'*w111;dw1'*dw1;dw11'*dw11;dw111'*dw111;dw1'*dw11;dw1'*dw111;dw11'*dw111];
if sum(temp(1:3))~=0
xd(1:12,i)=temp(1:12)/sum(temp(1:3));
else
xd(1:12,i)=temp(1:12)*0;
end
if sum(temp([1:3]+12))~=0
xd([1:12]+12,i)=temp([1:12]+12)/sum(temp([1:3]+12));
else
xd([1:12]+12,i)=temp(1:12)*0;
end
end
end
