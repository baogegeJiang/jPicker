setPath;
setPara;
loadFile;
clear quake0;
staNum=length(staLst);
for i=200:-1:1
    cR=0;
    while cR<0.6
    quake0(i).pTime=zeros(1,staNum);
    quake0(i).sTime=zeros(1,staNum);
    quake0(i).PS=[refDay-i+3000/86400-1000;la0+(rand-0.5)*r;lo0+(rand-0.5)*r;rand*40+5;1];
    n=ceil(rand*8+8);
    L=mod(ceil(rand(n,1)*1000),staNum)+1;
   % L=[mod(ceil(rand(ceil(n/2),1)*1000),28)+1;mod(ceil(rand(ceil(n/2),1)*1000),16)+1+28;]; 
    for j=L'
        quake0(i).pTime(j)=(taupnet(netPG,[quake0(i).PS(2:4);staLst(j).la;staLst(j).lo],1)+0.1*(rand-0.5))/86400+quake0(i).PS(1);
        
        if rand > 0.3
           quake0(i).sTime(j)=(taupnet(netSG,[quake0(i).PS(2:4);staLst(j).la;staLst(j).lo],2)+0.1*(rand-0.5))/86400+quake0(i).PS(1);
        end
    
    end
    cR=calCover(quake0(i),staLst);
    end
    fprintf('gen a quake la: %.2f lo: %.2f dep: %.2f no: %d cR: %.3f\n',quake0(i).PS(2),quake0(i).PS(3)...
    ,quake0(i).PS(4),sum(sign(quake0(i).sTime)),cR);
end
save([workDir,'/tool/locFunc/quake0Sim.mat'],'quake0');
