function [SA]=getSA(data)
data=data-mean(data);
data0=data.*0;
for i=2:length(data);
    data0(i,:)=data0(i-1,:)+data(i-1,:);
end
SA=norm(max(data0));
