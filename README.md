# jPickerV2

---

author: ***JIANG Yiran && Jerry Ning***  
Email: *2320140745@qq.com*

---

*a program to automaticlly detect earthquakes and determine the arrival times of its P S phases. it mainly based on supoort vector machine and can be applied on array data.*

**Emphasize**: our method are designed for 50HZ sac files. You may have to convert the format to sac and resample to 50 Hz or we would do resample automatically in our program. the whole program is mainly designed to process the full-day record and we also provide a function to picking phase on a short record for specific events. 

---

## 1 install step:

### 1.1 compile files(optional)
we give some optional way to process faster or more conveniently which need programs or functions not pre-built in matlab.
**if you don't need these, set mexSLR=0 && isJLoc=1 in setPara.m**

```matlab
cd tool/SLR;mex SLRC.cpp; 
```
we provide a way to calculate SLR(Allen, 1978) in 'C' using mex in MATLAB. it doesn't matter if you don't want to mex this file, as we provide an alternative option to do this without mexing which only costs a little longer time than the 'C' one.        
in the new version we develop a faster way to locate single earthquake in matlab to take place of the original 'velest' part  
so if set isJLoc=1, no need to compile velest program 


### 1.2 set paths, parameters and other things

#### 1.2.1 edit setPath.m :
workDir: the main folder's path where you place jPicker  
dataDir: the path of the folder saving sac files  
matDir:  the path of the folder saving the waveform data in .mat   
we provide an option to save the main waveform data in .mat form. You can review it by loading this files. it also contains some other informations. 
#### 1.2.2 edit setPara.m :
you can see the meaning of these detailed parameters in this file and adjust it according to your need.
#### 1.2.3 edit staLst : 
give the station list in this format: **net station component(ex. BH HH) longitude(-: W) latitude(-: S)**  
the number of station should be less than 26^2;(recommend: 10~50)   

#### 1.2.4 edit sacFileName.m  :
input the (net station comp dayNum), output the relative paths of three component sac files(to contain waveform for a full day numbered dayNum; see *data struct* for more information about daynum) in dataDir in cell format
like when
```maltab
dayNum = 735965;%datenum(2015,01,01)
```
```matlab 
sacE={'ABC.20150101.00.BHE.SAC','ABC.20150101.08.BHE.SAC','ABC.20150101.16.BHE.SAC'}
sacN={'ABC.20150101.00.BHN.SAC','ABC.20150101.08.BHN.SAC','ABC.20150101.16.BHN.SAC'}
sacZ={'ABC.20150101.00.BHZ.SAC','ABC.20150101.08.BHZ.SAC','ABC.20150101.16.BHZ.SAC'}
```
you should adjust the function according to your situation.when our program get the several file paths, we would automatically merge them together
#### 1.2.5 edit setPicker.m :
set some parameters using in SVM's picker. you can see details in it
### 1.3 initialize the program:
run the following script to initialize the picker  
#### 1.3.1 initPicker : 
We have write a script to initialize the environment according to your setting  
#### 1.3.2 genNewModelasp: 
to initialize taup acorrding to the velocity structure in :
```matlab
aspModelFile=[workDir,'/tool/mattaup/iasp91.tvel'];
```
and the result will be saved in
```matlab
modelLocalMat=[workDir,'/tool/mattaup/modelLocalasp.mat'];
```  
#### 1.3.3 genTaupNet: 
to pre-calcultate 1-D travel time according to aspModelFile and save the result to accelerate travel time calculation. (0.005° 1km)'s result would help us to interp travel time. it would cost a little longer time. if you don't change the velocity structure in aspModelFile, you need not to run this every time  
#### 1.3.4 genTimeLstMat:
we would divide the area into some subareas and we need to calculate the travel time range (P/S) for quakes in each subareas to each station. this script would do this and save the result in mat format
#### 1.3.5 loadFile: 
load the pre-calculated files which we will use in the process  
---
## 2 run  
```matlab
day=dayPick(sDay0,machineIsPhase,machineIsP) 
```  
pick on one day's data. as we run loadFile before, the machineIsPhase and machineIsP is alread in the workPlace. you just specific the day sDay0 you want to scan, it will return a day structure witch contains the found quakes. you can use datenum(year,month,day) to obtain sDay0. turn to *data struct* to know the details about datenum.  
**pickAIV2** : if you want to do pick-up on all the days, just run it. it will call dayPick to pick on each day.   

---

## 3 data struct：  
### 3.1 time: 
we use datenum to mark the time. it's a matlab function witch can convert time into a number. this number indicates how many day it is from 0000-00-00-0000. So, 1 secand will be convert into 1/86400 day.

#### 3.1.1 airrval time: 
to simplify the expression of arrival time, we introduce a 1-d array to record the arrival time. we would use datenum form. the stations‘ elements are numbered according to the sequence in staLst. if one element is zeros, it means do not find or can't determine the phase and its arrival time in the specific staion.
##### 3.1.2 pTime/sTime: 
we use this two kinds of arrays to present two different phases' arrival times in the above form

### 3.2 quake: 
{pTime;sTime;PS}. 
for one quake, we'd use a quake struct to indicate. it has three parts as we show. pTime and sTime are the arrival times in different stations.  
**PS** provides more information about the quake **[origin time;latitude；longitude；depth；magnitude]**. we just simplely estimate the magnitude according to the waveform data. if you are going to use quakes' magnitudes in your research we strongly recommend you to calculate these by yourself

### 3.3 latitude/longitude: 
E/N:+, W/S:-

### 3.4 depth: 
km

### 3.5 day: 
{n*quake}. a day struct will contain many quakes in quake struct.   

## 4 pick on a single station:  

```matlab
[pIndex,sIndex]=pPickerSingle(pIndex0,sIndex0,data,toDoLst,machineIsPhase,machineIsP)
```
this function proviede a way to do phasePicking on a single station.   
the waveform data is a N*3 mat which contains three components(E/N/Z).   
**pIndex0/sIndex0 :** is the phase's estimated arrival time's index. if you cannot give a accurate pIndex0 or sIndex0, just set them all 0 then the function would pick on the whole data and pick the first phase as P.  
**toDoLst :** is a parameter array to determine the way to pick: [svmPickP aicPickP svmPickS]. when one element is set to 1/0, the function will do or not do the corresponding picking. the default setting is [1 1 1]  
**machineIsPhase/machineIsP :** the already trained machines used in picking. they are stored in the tool/SVM/machineIsPhase.mat and tool/SVM/machineIsP.mat  
the function will return the index of P/S phase's arrival time. if the indexes equal to **0**, it means **no** phase of such type found.  