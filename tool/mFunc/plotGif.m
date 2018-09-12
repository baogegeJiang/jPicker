function[pCount]=plotGif(fileDir,outFile,dt)
L=dir([fileDir,'/*']);
pCount=0;
for i=1:length(L)
    tmp=L(i).name;
    if tmp(1)=='.';continue;end
    wL=700;hL=600;
    Img=imread([L(i).folder,'/',L(i).name]);
    Img=imresize(Img,[hL,wL]);
    figure(1)
    clf
    imshow(Img);
%    q=get(gca,'position');
%
%
%    set(gca,'position',q);
    frame=getframe(gca);
    im=frame2im(frame);
    imshow(im);
    [I,map]=rgb2ind(im,256);;
    if pCount==0;
        imwrite(I,map,outFile,'gif','Loopcount',inf,...
            'DelayTime',dt);%loopcount只是在i==1的时候才有用
    else
        imwrite(I,map,outFile,'gif','WriteMode','append',...
            'DelayTime',dt);%DelayTime用于设置gif文件的播放快慢
    end
    pCount=pCount+1;
    fprintf('have plot %d figures\n',pCount);
end
