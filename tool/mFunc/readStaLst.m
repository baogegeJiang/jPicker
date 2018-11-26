staStr=['YAY';'NIW';'SZZ';'DAX';'SHC';'YMG';'WUJ';'HSH';'LCH';'JIN';'CHS';'YUY';'YAG';'WTS';'SHZ';'LNQ';'TIY';'YAX';];
netStr=['SX' ;'SX' ;'SX' ;'SX' ;'SX' ;'SX' ;'HE' ;'SX' ;'NM' ;'NM' ;'SX' ;'SX' ;'SX' ;'SX' ;'SX' ;'SX' ;'SX' ;'SX' ;];
sacDir='/media/geodyn/shanxidata2/sacDir/20160101/'
outputFile='staLstSR'
f=cell(18,1);
for i=1:18
    net=netStr(i,:);
    sta=staStr(i,:);
    sacFile=[sacDir,net,'.',sta,'.','BHE','.','SAC'];
    f{i,1}=net;
    f{i,2}=sta;
    f{i,3}='BH';
    tmp=readsac(sacFile);
    f{i,4}=num2str(tmp.STLO);
    f{i,5}=num2str(tmp.STLA);
end
wfile(f,outputFile);
