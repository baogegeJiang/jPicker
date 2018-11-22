x=[0:10000000];pL=[];
for mul=0:10
    pL(end+1)=1/2+1/(2*pi)^0.5*sum(((x(2:end)-x(1:end-1))/x(end)*mul).*exp(-(x(2:end)/x(end)*mul).^2/2));
end
log10(1-pL)