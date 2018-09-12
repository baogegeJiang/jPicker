setPath
%dir='/home/jiangyr/VELSVM/';
NS='NS';
EW='EW';
dir=velDir0;
file=[dir,'ca1vel.sta'];
load staLst staLst
l=length(staLst);
f=cell(1,1);
f{1,1}=['(a4,f7.4,a1,1x,f8.4,a1,1x,i4,1x,i1,1x,i3,1x,f5.2,2x,f5.2)'];
for i=1:l
    name=staLst(i).nick;
    temp=name;
    temp=[temp,num2str(abs(staLst(i).la),'%.4f'),NS(1.5-sign(staLst(i).la)/2),' '];
    temp=[temp,num2str(abs(staLst(i).lo),'%.4f'),EW(1.5-sign(staLst(i).lo)/2),'    '];
    temp=[temp,'0 1'];
    temp=[temp,nspace(i,4,'%d',' '),'  '];
    temp=[temp,'0.00   0.00   1'];
    f{i+1,1}=temp;
end
f{l+2,1}=' ';
wfile(f,file);
