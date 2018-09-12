function[ ]=plotRec(pos,c)
plot(pos(1)+[0,pos(3)],[pos(2),pos(2)],c);
plot(pos(1)+[0,pos(3)],[pos(2),pos(2)]+pos(4),c);
plot(pos(1)+[0,0],[pos(2),pos(2)+pos(4)],c);
plot(pos(1)+[pos(3),pos(3)],[pos(2),pos(2)+pos(4)],c);
end
