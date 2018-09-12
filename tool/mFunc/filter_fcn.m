function [ data ] = filter_fcn( data,delta,mode,order,f,nodelay )
N_max=200;
l=length(data);fl=max([1/l,f(1)*delta*2,1/N_max*delta*2]);fh=min(0.99,f(2)*delta*2);
al=1;bl=1;ah=1;bh=1;
switch mode
    case 'butter'
        [bl,al]=butter(order,fl,'high');
        [bh,ah]=butter(order,fh,'low');
    case 'bessel'
        bl=1;al=1;
        [bh,ah]=besself(order,fh);
    case 'butter1'
         [bl,al]=butter(order,[fl fh],'bandpass');
end
switch nodelay
    case 1
        data=filtfilt(bl,al,data);
        data=filtfilt(bh,ah,data);
    case 1.5
        data=gpuArray(data);
        data=filtfilt(bl,al,data);
        data=filtfilt(bh,ah,data);
        data=gather(data); 
    case 0
        data=filter(bl,al,data);
        data=filter(bh,ah,data);
    case 0.5
        data=gpuArray(data);
        data=filter(bl,al,data);
        data=filter(bh,ah,data);
        data=gather(data);
    case 2
        data=filter(bl,al,data);
    case 2.5
        data=gpuArray(data);
        data=filter(bl,al,data);
        data=gather(data);

end
end


