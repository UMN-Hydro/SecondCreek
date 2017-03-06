% Calculate difference between head at SG-1 nad PZ-CC


clear all
close all
format long g
%import necessary files
PZCC1 = load( 'C:\SecondCreekGit\Scripts\PZ-CC_161005_Calib20161001_1300_results.mat');
PZCC2 = load( 'C:\SecondCreekGit\Scripts\PZ-CC_161005_Calib20161001_1300_results.mat');

SG11 = load('C:\SecondCreekGit\Scripts\SG-1_1st_Position_161005_Calib20160531_0945_results.mat');
SG12 = load('C:\SecondCreekGit\Scripts\SG-1_2nd_Position_161005_Calib20161001_1430_results.mat');

%extract date data
dateSG11 = datenum(SG11.DivDateTime);
dateSG12 = datenum(SG12.DivDateTime);
datePZCC1 = datenum(PZCC1.DivDateTime);
datePZCC2 = datenum(PZCC2.DivDateTime);


%find starting and ending times
Time1 = max([min(dateSG11), min(datePZCC1)]);
TimeEnd = min( [max(dateSG11), max(datePZCC1)]);

%truncate each time array
[PZCC1strt,col] = find(datePZCC1 == Time1);
[SG11strt,col] = find(dateSG11 == Time1);


[PZCC1end,col] = find(datePZCC1 == TimeEnd);
[SG11end,col] = find(dateSG11 == TimeEnd);


PZCC1adjustedT = datePZCC1(PZCC1strt : PZCC1end);
SG11adjustedT= dateSG11(SG11strt : SG11end);

%change date format
SG11adjustedT = datestr(SG11adjustedT, 'mm/dd/yyyy HH:MM');
PZCC1adjustedT = datestr(PZCC1adjustedT, 'mm/dd/yyyy HH:MM');

PZCC1adjustedT= table(PZCC1adjustedT);
SG11adjustedT= table(SG11adjustedT);


%import head data
headSG11 = SG11.DivTotHead/100;
headPZCC1 = PZCC1.DivTotHead/100;

%truncate head data
PZCC1adjustedH= headPZCC1(PZCC1strt : PZCC1end);
SG11adjustedH= headSG11(SG11strt : SG11end);
%calculate difference
headDiff1 = PZCC1adjustedH-SG11adjustedH;


%output file


 %fileID = 'TPA_headDiff1_1DTempPro.csv';

 
fileID = fopen('C:\SecondCreekGit\TempProbeAnalysis\HeadDiff1_1DTempPro.csv','w');
 [nrows, ncols] = size(SG11adjustedH);


for row = 1:nrows
   
   fprintf(fileID, '%s%s%f\r\n', SG11adjustedT{row,1} , ', ', headDiff1(row,1));
end

%repeat for second chunk of summer

%find starting and ending times
Time1 = max([min(dateSG12), min(datePZCC2)]);
TimeEnd = min( [max(dateSG12), max(datePZCC2)]);

%truncate each time array
[PZCC2strt,col] = find(datePZCC2 == Time1);
[SG12strt,col] = find(dateSG12 == Time1);


[PZCC2end,col] = find(datePZCC2 == TimeEnd);
[SG12end,col] = find(dateSG12 == TimeEnd);


PZCC2adjustedT = datePZCC2(PZCC2strt : PZCC2end);
SG12adjustedT= dateSG12(SG12strt : SG12end);

%change date format
SG12adjustedT = datestr(SG12adjustedT, 'mm/dd/yyyy HH:MM');
PZCC2adjustedT = datestr(PZCC2adjustedT, 'mm/dd/yyyy HH:MM');

PZCC2adjustedT= table(PZCC2adjustedT);
SG12adjustedT= table(SG12adjustedT);


%import head data
headSG12 = SG12.DivTotHead/100;
headPZCC2 = PZCC2.DivTotHead/100;

%truncate head data
PZCC2adjustedH= headPZCC2(PZCC2strt : PZCC2end);
SG12adjustedH= headSG12(SG12strt : SG12end);
%calculate difference
headDiff2 = PZCC2adjustedH-SG12adjustedH;








%output file



 fileID = fopen('C:\SecondCreekGit\TempProbeAnalysis\HeadDiff2_1DTempPro.csv','w');

[nrows, ncols] = size(SG12adjustedH);


for row = 1:nrows
   
        fprintf(fileID, '%s%s%f\r\n', SG12adjustedT{row,1}, ', ', headDiff2(row,1));
end



