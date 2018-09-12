function [K] = kernel( x1,x2,kernelModel,p )
    % K=f(x1,x2,kernelModel,p)
switch kernelModel
    case 'RBF'
        M1 = ones(size(x2,2),1)*sum(x1.^2,1);
        M2 = ones(size(x1,2),1)*sum(x2.^2,1);
        K = M1'+M2- 2*x1'*x2;
        K=K*(2*p(1))^(-1);
        K = exp(K);
    case 'linear'
        K=x1'*x2;
    case 'poly'
        p(2)=ceil(p(2));
        K= (x1'*x2+p(1)).^p(2);
    case 'wRBF'
        for i=1:size(x1,2)
        X1(:,i)=abs(cwt(x1(:,i),p(1),'cmor1-1.5'));
        end
        for i=1:size(x2,2)
        X2(:,i)=abs(cwt(x2(:,i),p(1),'cmor1-1.5')); 
        end
        K=kernel(X1,X2,'RBF',p(2));
    case 'wpoly'
       for i=1:size(x1,2)
        X1(:,i)=abs(cwt(x1(:,i),p(1),'cmor1-1.5')); 
        end
        for i=1:size(x2,2)
        X2(:,i)=abs(cwt(x2(:,i),p(1),'cmor1-1.5'));
        end
        K=kernel(X1,X2,'poly',p(2:3));       
end
end
