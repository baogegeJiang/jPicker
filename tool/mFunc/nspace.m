function [temp] = nspace( num,n,type,fill )
%to print the num as you want
temp=num2str(num,type);
for i=length(temp)+1:n
    temp=[fill,temp];
end
end

