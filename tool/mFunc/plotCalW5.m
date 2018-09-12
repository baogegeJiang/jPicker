function [ ]=plotCalW5(loopPlot,b)
filename= 'temp.gif';wL=600;hL=600;
for i=1:length(loopPlot)
    fprintf('plot %d\n',i);
    hold off
   % ylim([-10,10]);
    for j=1:length(loopPlot(i).tempValue)
    if loopPlot(i).y(j)>0
       plot(j,loopPlot(i).tempValue(j),'ob');hold on
    else
      plot(j,loopPlot(i).tempValue(j),'+r');hold on
    end
    end
    if i>=length(loopPlot)-5
    plot([-1,length(loopPlot(i).tempValue)],[-b,-b]);
    end
    legend('phases','noise');
    title(['loop: ',num2str(loopPlot(i).loopIndex),'   -0.5*a^T*a+1*a =',sprintf('%.3f',loopPlot(i).v)]);
    ylim([-10,10]);
    xlim([0,length(loopPlot(i).y)]);
   xlabel('index');
   ylabel('output Value');
    % plot(sin([1:100]/i));
    hold off
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6 6]);
    set(gca,'FontSize',16,'FontName','Times New Roman');
    filename= 'temp.gif';wL=600;hL=600;
    jpgName='temp.jpg';
    %saveas(gcf,jpgName);
    print(gcf,'-djpeg','-r150',jpgName);
    Img=imread(jpgName);
    Img=imresize(Img,[hL,wL]);
    figure(1)
    imshow(Img);
    q=get(gca,'position');


    set(gca,'position',q);
    frame=getframe(gca);
    im=frame2im(frame);
    imshow(im);
    [I,map]=rgb2ind(im,256);
    k=i-0;
    if k==1;
        imwrite(I,map,filename,'gif','Loopcount',inf,...
            'DelayTime',1);%loopcount只是在i==1的时候才有用
    else
        imwrite(I,map,filename,'gif','WriteMode','append',...
            'DelayTime',1);%DelayTime用于设置gif文件的播放快慢
    end
end
close all;

