%if isStrict == 1, we would pick phases in a strict way; this will be usedful when your data's quality is not so good.
isStrict=1;
% search range. when a estimated arrival time is given, we will do our picker around it. the range is determined by the following array
% jL for P; jLS? for S. as our data have already converted into 50 Hz, [-50:50] means [-1 sec, 1 sec]. if your estimated time is not so
%accurate, a wide range will be more suitable.
%jL=[-250:250];jLS1=[-250:300];jLS2=[-250:300];jLS=[-250:300];
jL=[-150:200];jL1=[-200:200];jLS1=[-200:250];jLS2=[-200:250];jLS=[-200:250];
jL=[-150:100];jL1=[-150:150];jLS1=[-150:150];jLS2=[-125:176];jLS=[-150:200];
