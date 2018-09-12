function [data,indexLst]=sacPre(sacE,sacN,sacZ);
bTime=clock;
delta=sacE.DELTA;
f=[2,10]; nodelay=2; mode='butter1';delta1=0.02;order=4;
delta0=sacE.DELTA;
f1=ceil(1/delta1); 
f0=ceil(1/delta0);
%sacE.DATA1=filter_fcn(  sacE.DATA1,delta0,mode,order,f,nodelay );
%sacN.DATA1=filter_fcn(  sacN.DATA1,delta0,mode,order,f,nodelay );
%sacZ.DATA1=filter_fcn(  sacZ.DATA1,delta0,mode,order,f,nodelay );
bE=ceil((sacE.NZHOUR*3600+sacE.NZMIN*60+sacE.NZSEC+sacE.NZMSEC/1000+sacE.B)/delta);
bN=ceil((sacN.NZHOUR*3600+sacN.NZMIN*60+sacN.NZSEC+sacN.NZMSEC/1000+sacN.B)/delta);  
bZ=ceil((sacZ.NZHOUR*3600+sacZ.NZMIN*60+sacZ.NZSEC+sacZ.NZMSEC/1000+sacZ.B)/delta);  
for i=0:9
varName=['sacE.T',num2str(i)];
tName=['t(',num2str(i+1),')'];
eval(['if isnan(',varName,')==0;',tName,'=',varName,';else ',tName,'=-99999;end']);
end


eE=bE+sacE.NPTS-1;
eN=bN+sacN.NPTS-1; 
eZ=bZ+sacZ.NPTS-1;
b=max([bE,bN,bZ]);
e=min([eE,eN,eZ]);
L=b:e;
data=[sacE.DATA1(L-bE+1),sacN.DATA1(L-bN+1),sacZ.DATA1(L-bZ+1)];
for i=1:10
if t(i)~=-99999
indexLst(i)=ceil(ceil((t(i)+sacE.NZHOUR*3600+sacE.NZMIN*60+sacE.NZSEC+sacE.NZMSEC/1000)/delta-b+1)*delta/delta1);
else
indexLst(i)=-1;
end
end
fprintf('sac2data used time:  %f s\n',etime(clock,bTime));
