dataDir='G:\XA_HSR_DATA\period2\SAC\PKU';
dDir='H:/ÐÛ°²/';
for i=37:65
     try
    if i==59;continue;end
    tmpDir= sprintf('%s\\PKU%d_day\\',dataDir,i);
    %sprintf('%s\\PK.PK0%d.00.BHZ.20180505.SAC',tmpDir,i)
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHN.20180515.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHE.20180515.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHZ.20180515.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHN.20180516.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHE.20180516.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHZ.20180516.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHN.20180517.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHE.20180517.SAC',tmpDir,i),dDir);
    copyfile(sprintf('%s\\PKU.PKU%d.00.BHZ.20180517.SAC',tmpDir,i),dDir);  
     end
end
