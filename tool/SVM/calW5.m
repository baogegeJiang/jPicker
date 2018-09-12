function [ a,b,report,x,y] = calW5( x,y,kernelModel,gam,p )
%% train the machine
y=sign(y);
t0=clock;
xm=size(x,2);
%C=1/15;step=1/xm;
C=1/15;step=1/xm;
x0=x;y0=y;
num=size(x,2);
num1=ceil(9/10*num);
x=x0(:,1:num1);
y=y0(1:num1);
xt=x0(:,num1+1:num);
yt=y0(num1+1:num);
loopM=1;
doDisplay=0;
fprintf('  Support Vector Machine    \n');
fprintf('author: JIANG Yiran    \n'); 
fprintf('Email : 1701210193@pku.edu.cn    \n \n');  
fprintf('calculate the Matrix K ...\n');
xm=size(x,2);
report=[];
K=kernel(x,x,kernelModel,p);
thres=0.0001;
Q=(y*y').*K;
a=ones(xm,1)*C*0.1/xm;
fprintf('calculate a  ...\n');
loopCount=0;
perLoop=ceil(xm/loopM);
for l=1:500*xm;

    if mod(l,perLoop)==0 && v(l-1)<=0;
       fprintf('loop: %d  v= %2.5f   used time: %3.2f s\n',[l-1,v(l-1),etime(clock,t0)]);
       if (v(l-1)<v(l-perLoop+1)*(1-thres))&&l/perLoop>20
        break;
       end
       loopCount=loopCount+1;
       loopPlot(loopCount).tempValue=tempValue;
       loopPlot(loopCount).v=v(l-1);
       loopPlot(loopCount).loopIndex=l-1;
       loopPlot(loopCount).y=y;
    end

    if mod(l,perLoop)==0 && v(l-1)>0
       fprintf('loop: %d  v= %2.5f   used time: %3.2f s\n',[l-1,v(l-1),etime(clock,t0)]);    
       if (v(l-1)<v(l-perLoop+1)*(1+thres))&&l/perLoop>5
          break;
       end
       loopCount=loopCount+1;
       loopPlot(loopCount).tempValue=tempValue;
       loopPlot(loopCount).v=v(l-1);
       loopPlot(loopCount).loopIndex=l-1;
       loopPlot(loopCount).y=y;
    end 
   
   tempValue=K*(a.*y);
   [minP,minPIndex]=min((tempValue+1000).*(y+1));
   [maxP,maxPIndex]=max((tempValue+1000).*(-y+1));
   minP=tempValue(minPIndex);maxP=tempValue(maxPIndex);
   isI=0;isJ=0;
   v(l)=sum(a)-0.5*a'*Q*a;
   if minP>maxP;displa('ok');break;end
   for ii=1:xm*2  
      temp=ceil(rand(1,1)*xm*10);
      i=mod(temp,xm)+1;
      if (a(i)<C & a(i)>0) & ((y(i)==1 & tempValue(i)<maxP)|(y(i)==-1 & tempValue(i)>minP));isI=1;break;end
   end
   if isI==0;continue;end
   tempAbsE=-inf;tempAbsEIndex=0;
   for jj=1:ceil(xm/20)
      temp=ceil(rand(1,1)*xm*10);
      j=mod(temp,xm)+1;
      if i==j;continue;end
      if abs(tempValue(i)-tempValue(j)-y(i)+y(j))>tempAbsE;tempAbsE=abs(tempValue(i)-tempValue(j)-y(i)+y(j));tempAbsEIndex=j;isJ=1;end
   end
  
   if isJ==0;continue;end
   if rand>0.2;j=tempAbsEIndex;end
 
    S=y(i)*a(i)+y(j)*a(j)-y'*a;
    k=-y(i)/y(j);
    b=S/y(j);
   
    a1=-b/k;
    a2=(C-b)/k;
    amin=max(0,min(a1,a2));
    amax=min(C,max(a1,a2));
    A1=1-(Q(i,:)*a-Q(i,i)*a(i)-Q(i,j)*a(j));
    B1=1-(Q(j,:)*a-Q(j,j)*a(j)-Q(i,j)*a(i));
    C1=-Q(i,j);
    A2=-0.5*Q(i,i);
    B2=-0.5*Q(j,j);
    
    D1=(A2+B2*k^2+C1*k);
    D2=(A1+k*B1+2*B2*k*b+C1*b);
    if D1==0
        if D2==0
            v(l)=sum(a)-0.5*a'*Q*a;
            continue;
        end
        if D2>0;
            a1=amax;
        else
            a1=amin;
        end
        
    elseif D1>0;
       
        if (amax+D2/(2*D1))^2 >(amin+D2/(2*D1))^2
            a1=amax;
        else
            a1=amin;
        end
    else
      
        if(amax+D2/(2*D1))*(amin+D2/(2*D1))<0
      
          a1=-D2/(2*D1);
        else
         if (amax+D2/(2*D1))^2 >(amin+D2/(2*D1))^2
            a1=amin;
        else
            a1=amax;
        end
        end
    end
a2=k*a1+b;
a(i)=a1;
a(j)=a2;
v(l)=sum(a)-0.5*a'*Q*a;

end

bL=find((abs(a)-0.001).*(abs(a)-0.99*C)<0);
a=a.*y;
temp=calValue( x,x,a,0,kernelModel,p );
tempB=temp(bL);
yB=y(bL);

b=0;cc=1/(2*C);
for i=1:1000
    b=b+step*sum((yB+1)*0.5-(1+exp(-(cc*tempB+b))).^(-1));
    vv(i)=sum((y+1)*0.5-(1+exp(-(cc*temp+b))).^(-1));
end

b=b/cc;
%}
minT=inf;
maxT=-inf;
minCount=0;
maxCount=0;
for i=1:length(temp)
    if abs(a(i))<0.00001||abs(a(i))>0.9999*C;continue;end
    if y(i)>0 
       minT=min([temp(i),minT]);
       minCount=minCount+1;
       minL(minCount)=temp(i);
    elseif y(i)<0
       maxT=max([temp(i),maxT]);
       maxCount=maxCount+1;
       maxL(maxCount)=temp(i);
    end
end
minL=sort(minL);
maxL=-sort(-maxL);
for i=1:min([length(maxL),length(minL)])
    minT=minL(i);
    maxT=maxL(i);
    if minT>maxT
       break;
    end
end

b=-(minT+maxT)/2;
y1=sign(yt);
y2=sign(calValue(x,xt,a,b,kernelModel,p));
report.testY=abs(y1-y2)/2;
report.testX=xt;
report.y1=y1;
try report.loopPlot=loopPlot;end
dNum=sum(abs(y1-y2)/2,1);
supNum=length(yt)-dNum;
per=supNum/length(yt);
count=0;
for i=1:length(a)
    if a(i)==0
       continue;
    end
    count=count+1;
    aF(count,1)=a(i);
    yF(count,1)=y(i);
    xF(:,count)=x(:,i);
end
a=aF;
x=xF;
y=yF;
report.supNum=supNum;
report.per=per;
report.v=v;
report.K=K;
report.Q=Q;
report.xt=xt;
fprintf('\nsupport vectors      : %d\n',size(a,1));
fprintf('separable percentage : %3.3f %%\n',report.per*100);
fprintf('used time : %4.2f s\n',etime(clock,t0));
if doDisplay;plotCalW5(loopPlot,b);end


end
