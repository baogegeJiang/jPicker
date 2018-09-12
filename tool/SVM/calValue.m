function [ value ] = calValue( xt,x,a,b,kernelModel,p )
	K=kernel(xt,x,kernelModel,p);
	value=(K'*a+b);
end

