% we provide the paralle way; paraNum is the number of threads. if it's setted to 1, we will not do paralle calculation
paraNum=1;
% when mexSLR ==1, we will calculate SLR in 'C'; when mexSLR==0, we will not;
mexSLR=0;
minSLR=3;
% set the scnday list. 
% refDay: not important parameter; set any day ealier than sDay is ok;
% sDay: the first day's number;
% eDay: the last day's number
refDay=datenum(2018,1,1);sDay=datenum(2018,7,1);eDay=datenum(2018,7,1);
% we can generate some simulate quakes to help us locate quakes. set the center point and max distance away from the center point***
% in the new version, we develop a new we to locate. so it was no longer needed if you set isJLoc=1;
lo0=-147;la0=60;r=3;
% if you need do filting on your data, set doFilt = 1 and set other filt parameters to suitable values else set do filt=0;
% we only provide butterworth filter (set mod='butter1'); you can use filt(nodelay=0) or filtfilt(nodelay=0);
% delta1 is the sample interval of sac (s). we would automatically resample it to 50 Hz. so don't change delta1.
doFilt=1;
f=[2,20];nodelay=1; delta1=0.02;order=4;mode='butter1';
% doLoc=1: locate quakes and using these results to improve the accuracy; doLoc=0: not locate
% set isJLoc=1, we would use our new method to locate.
doLoc=1;isJLoc=1;
% reDet=1,2,3...: we will relocate and re-pick record several times to improve the accuracy; reDet=0: not relocate and re-pick
% in the new version, the accuracy has been improved a lot. so set reDet=0 is already enough
reDet=0;
% saving the main waveform data in .mat form in the matDir
saveSta=1;
% fastCal=1: do calculation in a fast way; fastCal=0: not in a fast way
% fastCalNum=1~25, the bigger the faster.
fastCal=1;
fastCalNum=25;
% reScan=1,2,3...: we will rescan the wavoform record several times to find if there is any missed quakes; reScan=0: not rescan
% 4 is already enough if there are not many earthquakes
reScan=4;
% dmax: the max distance(km) between the quakes and stations when we locate the quakes
dmax=500; 
% using the global variable to reduce the usage of memory
% don't change this
globalSta=1;
% the parameters using in stacking Sec and finding orign time. using the default setting is enough
dd1=0.1;dd2=0.01;dd3=0.01;
% we divide the area into many subareas 
% R=[minLatitude maxLatitude minLongitude maxLongitude] define the whole area
% nR: the subarea's latitude range= (maxLatitude-minLatitude)/(nR-1)
% mR: the subarea's longitude range= (maxLongitude-minLongitude)/(nR-1)
% the total number of subareas: nR*mR
R=[53,68,-155,-135];nR=15;mR=15;
% dTimeE for travel time calculate error (in associating different stations' results) 
% if the travel time is longer or shorter than the estimated range within dTimeE, 
% it also be taken into consideration
dTimeE=2;

