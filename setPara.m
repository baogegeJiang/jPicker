% we provide the paralle way; paraNum is the number of threads. if it's setted to 1, we will not do paralle calculation
paraNum=15;
% when mexSLR ==1, we will calculate SLR in 'C'; when mexSLR==0, we will not;
mexSLR=1;
minSLR=4;
% set the scnday list. the refDay should be ealier than sDay.*
%1508282016033123
%1503270015082820/
%1410090015032623
refDay=datenum(2013,1,1);sDay=datenum(2014,10,09);eDay=datenum(2015,03,26);
% we can generate some simulate quakes to help us locate quakes. set the center point and max distance away from the center point***
lo0=107;la0=39.2;r=2;
% if you need do filting on your data, set doFilt = 1 and set other filt parameters to suitable values else set do filt=0;
doFilt=0;
f=[2,20]; nodelay=1; mode='butter1';delta1=0.02;order=4;
% doLoc=1: locate quakes and using these results to improve the accuracy; doLoc=0: not locate
doLoc=1;
% reDet=1,2,3...: we will relocate and re-pick record several times to improve the accuracy; reDet=0: not relocate and re-pick
reDet=0;
% saving the main waveform data in .mat form in matDir
saveSta=1;
% fastCal=1: do calculation in a fast way; fastCal=0: not in a fast way
% fastCalNum=1~25, the bigger the faster.
fastCal=1;
fastCalNum=25;
% reScan=1,2,3...: we will rescan the wavoform record several times to find if there is any missed quakes; reScan=0: not rescan
reScan=4;
% dmax: the max distance(km) between the quakes and stations when we locate the quakes
dmax=500; 
% using the global variable to reduce the usage of memory
globalSta=1;
% the parameters using in stacking Sec and finding orign time. using the default setting is enough
dd1=0.1;dd2=0.01;dd3=0.01;
%% we divide the area into many subareas 
R=[36,42,103,111];nR=10;mR=10;
dTimeE=2;
isJLoc=1;
