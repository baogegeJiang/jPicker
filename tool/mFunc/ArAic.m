function [ maxK,valueK ] = ArAic(data,M  )
[l,m]=size(data);
if l<m
    data=data';
end
for k=3*M+1:length(data)-3*M-1
    M1=[];M2=[];L1=[];L2=[];R1=[];R2=[];
    for j=M+1:k
        M1(j-M,1:M)=data(j-M:j-1);
        R1(j-M,1)=data(j);
    end
    
    for j=k+1+M:length(data)
        M2(j-k-M,1:M)=data(j-M:j-1);
        R2(j-k-M,1)=data(j);
    end
    
    L1=M1\R1;%(M1'*M1)\(M1'*R1);
    L2=M2\R2;%(M2'*M2)\(M2'*R2);
    
    dR1=M1*L1-R1;
    dR2=M2*L2-R2;
    
    %var1=var(dR1)*(length(dR1))/(length(dR1)-1);
    %var2=var(dR2)*length(dR2)/(length(dR2)-1);
    var1=dR1'*dR1/length(dR1);
    var2=dR2'*dR2/length(dR2); 
   
    
    valueK(k-3*M)=-0.5*(length(dR1)-M)*log(var1)...   
    -0.5*(length(dR2)-M)*log(var2);
end
    [l,maxK]=max(valueK);
    maxK=maxK+3*M;
    valueK=[min(valueK)*ones(1,3*M),valueK,min(valueK)*ones(1,3*M+1)];
end

