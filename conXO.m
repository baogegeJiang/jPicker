function [x]= conXO(index,data)
setPara;
% if mexConX==1
%     bIndex=max(1,min(index)-81000);
%     eIndex=min(size(data,1),max(index)+8100);
%     x=conXC_mex(index-bIndex+1,data(bIndex:eIndex,:),fastCal,fastCalNum);
% %return;
% end
windowLength=75;
windowLength1=75;%30
len=length(data);
index0=index;
mul=1;
mul1=1;
i1=[1:40].^2*5+windowLength;
i2=[0:39].^2*5+windowLength;
xp=zeros(length(i1),1,'single');
xb=zeros(length(i1),1,'single');
x=zeros(382,length(index),'double');
if fastCal==0
   for i=1:length(index0)
       index=index0(i);
       x10=data(index-windowLength:index+windowLength,1);
       x110=data(index-windowLength:index+windowLength,2);
       x111=(x10.^2+x110.^2).^(1/2)/mul1;
       for j=1:length(i1)
           xp(j,1)=norm(data(mod(index-i1(j):3:index-i2(j)-1,len)+1,:),'fro')/((i1(j)-i2(j)+1))^0.5;
           xb(j,1)=norm(data(mod(index+i2(j):3:index+i1(j)-1,len)+1,:),'fro')/((i1(j)-i2(j)+1))^0.5;
       end
       xTemp=[x111;data(index-windowLength:index+windowLength,3);xp/mul;xb/mul];
       x(:,i)=xTemp;
       %x(:,i)=x(:,i)/norm(abs(x(1:302,i)));
   end
else
   indexTmp=-1000;
   for i=1:length(index0)
       index=index0(i);
       x10=data(index-windowLength:index+windowLength,1);
       x110=data(index-windowLength:index+windowLength,2);
       x1=data(index:index+windowLength1,1);
       x11=data(index:index+windowLength1,2);
       x111=(x10.^2+x110.^2).^(1/2)/mul1;
       for j=1:5
           xp(j,1)=norm(data(mod(index-i1(j):3:index-i2(j)-1,len)+1,:),'fro')/((i1(j)-i2(j)+1))^0.5;
           xb(j,1)=norm(data(mod(index+i2(j):3:index+i1(j)-1,len)+1,:),'fro')/((i1(j)-i2(j)+1))^0.5;
       end
       if abs(index-indexTmp)>fastCalNum
          indexTmp=index;
          for j=6:length(i1)
              xp(j,1)=norm(data(mod(index-i1(j):3:index-i2(j)-1,len)+1,:),'fro')/((i1(j)-i2(j)+1))^0.5;
              xb(j,1)=norm(data(mod(index+i2(j):3:index+i1(j)-1,len)+1,:),'fro')/((i1(j)-i2(j)+1))^0.5;
          end
       end
       xTemp=[x111;data(index-windowLength:index+windowLength,3);xp/mul;xb/mul];
       x(:,i)=xTemp;
       %x(:,i)=x(:,i)/norm(abs(x(1:302,i)));
end
end
