% Calculate difference between head at SG-1 nad PZ-CC


clear all
close all
format long g
%import necessary files
PZCC = load( 'C:\SecondCreekGit\Scripts\PZ-CC_161005_Calib20161001_1300_results.mat')
SG11 = load('C:\SecondCreekGit\Scripts\SG-1_1st_Position_161005_Calib20160531_0945_results.mat')
SG12 = load('C:\SecondCreekGit\Scripts\SG-1_2nd_Position_161005_Calib20161001_1430_results.mat')

%extract date data
dateSG11 = datenum(SG11.DivDateTime);
dateSG12 = datenum(SG12.DivDateTime);
datePZCC = datenum(PZCC.DivDateTime);

%find starting and ending times
Time1 = max([min(dateSG11), min(datePZCC)]);
TimeEnd = min( [max(dateSG11), max(datePZCC)]);

%truncate each time array
[PZCCstrt,col] = find(datePZCC == Time1);
[SG11strt,col] = find(dateSG11 == Time1);


[PZCCend,col] = find(datePZCC == TimeEnd);
[SG11end,col] = find(dateSG11 == TimeEnd);


PZCCadjustedT = datePZCC(PZCCstrt : PZCCend);
SG11adjustedT= dateSG11(SG11strt : SG11end);

%change date format
SG11adjustedT = datestr(SG11adjustedT, 'mm/dd/yyyy HH:MM');
PZCCadjustedT = datestr(PZCCadjustedT, 'mm/dd/yyyy HH:MM');



%import head data
headSG11 = SG11.DivTotHead/100;
headPZCC = PZCC.DivTotHead/100;

%truncate head data
PZCCadjustedH= headPZCC(PZCCstrt : PZCCend);
SG11adjustedH= headSG11(SG11strt : SG11end);
%calculate difference
headDiff1 = PZCCadjustedH-SG11adjustedH;


%output file


 %fileID = 'TPA_headDiff1_1DTempPro.csv';


fileID = fopen('HeadDiff1_1DTempPro.csv','w');
 [nrows, ncols] = size(SG11adjustedH);


for row = 1:nrows
   
   fprintf(fileID, '%s%s%f\r\n', SG11adjustedT(row,1), ', ', headDiff1(row,1));
end

%repeat for second chunk of summer

%find starting and ending times
Time1 = max([min(dateSG12), min(datePZCC)]);
TimeEnd = min( [max(dateSG12), max(datePZCC)]);

%truncate each time array
[PZCCstrt,col] = find(datePZCC == Time1);
[SG12strt,col] = find(dateSG12 == Time1);


[PZCCend,col] = find(datePZCC == TimeEnd);
[SG12end,col] = find(dateSG12 == TimeEnd);


PZCCadjustedT = datePZCC(PZCCstrt : PZCCend);
SG12adjustedT= dateSG11(SG12strt : SG11end);

%change date format
SG12adjustedT = datestr(SG12adjustedT, 'mm/dd/yyyy HH:MM');
PZCCadjustedT = datestr(PZCCadjustedT, 'mm/dd/yyyy HH:MM');



%import head data
headSG12 = SG12.DivTotHead/100;
headPZCC = PZCC.DivTotHead/100;

%truncate head data
PZCCadjustedH= headPZCC(PZCCstrt : PZCCend);
SG12adjustedH= headSG11(SG12strt : SG12end);
%calculate difference
headDiff2 = PZCCadjustedH-SG12adjustedH;








%output file



 fileID = 'TPA_headDiff2_1DTempPro.csv';
 fopen(fileID, 'w');
[nrows, ncols] = size(SG11adjustedH);


for row = 1:nrows
   
        fprintf(fileID, '%s%s%f\r\n', SG12adjustedT(row), ', ', headDiff2(row));
end



