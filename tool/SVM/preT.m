function [pre,m1]=preT(xt,m)
	pre=single(calValue(m.x,xt,m.a,m.b,m.kernelModel,m.sig2));
	m1=0;
end
