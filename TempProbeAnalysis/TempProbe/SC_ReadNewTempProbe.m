%% Script for reading and plotting New Temp Probe Data
    % - reads in a .csv or .txt file where all data is separated by comma
    % - converts unix time in data file to matlab datetime, then to centratal
    % date and time
    % - trims unnecessary data (see section 3 to change time)
    % - averages multiple sets of measurements for each recorded time
    % - plots data
    
    % Incorporates calibraion values for each thermister (see
    % C:\Users\Amanda\Desktop\Research\Scripts\NewTempProbes\ReadCalData.m)

clear all
close all
format long g %gets rids of scientific notation

ntherm = 6 ; %number thermisters/probe

% 1. Specify and read temp probe files 
% 
%     %file identifiers (June 13th download)
%     SCTempProbeA_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\2016_06_13_download\Logger_A_20160613.txt' ;
%     SCTempProbeB_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\2016_06_13_download\Logger_B_20160613.txt' ;
%     SCTempProbeC_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\2016_06_13_download\Logger_C_20160613.txt' ;


    %file identifiers (oct 4 download)
    SCTempProbeA_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\2016_10_04_download\Logger_A_20160410.txt' ;
    SCTempProbeB_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\2016_08_01_download\Logger_B_20160801.txt' ;
    SCTempProbeC_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\2016_08_01_download\Logger_C_20160801.txt' ;
    SCCal_fil = 'C:\Users\Amanda\Desktop\Research\Scripts\NewTempProbes\TempProbCalAvg_2016.dat' ;
    
    %read csv file
    TP_A = csvread(SCTempProbeA_fil);
    TP_B = csvread(SCTempProbeB_fil);
    TP_C = csvread(SCTempProbeC_fil);
    Cal_all = csvread(SCCal_fil);

% 2. Time Conversion
    %isolate unix time column and adjust for time difference. Central time is -05.00 hrs
    %from UTC during the summer = -18000 second from unix time. Store in
    %new column vector
    unix_timeA = TP_A(:,1)-18000;
    unix_timeB = TP_B(:,1)-18000;
    unix_timeC = TP_C(:,1)-18000;
    
    %Clear first column of array
    TP_A (:,1) = [];
    TP_B (:,1) = [];
    TP_C (:,1) = [];

    %Unix time to matlab time
    matlab_timeA = unix_timeA./86400 + datenummx(1970,1,1,0,0,0);
    matlab_timeB = unix_timeB./86400 + datenummx(1970,1,1,0,0,0);
    matlab_timeC = unix_timeC./86400 + datenummx(1970,1,1,0,0,0);
    
    %matlab time to regular time 
    RegularPersonTimeA = datetime(matlab_timeA,'ConvertFrom','datenum');
    RegularPersonTimeB = datetime(matlab_timeB,'ConvertFrom','datenum');
    RegularPersonTimeC = datetime(matlab_timeC,'ConvertFrom','datenum');


% 3. ****** SET DATE BEGINNING DATETIME (datetime that probes were inserted
    time_ix_A = find((RegularPersonTimeA(:,1)== '30-May-2016 16:00:00'));
    time_ix_B = find((RegularPersonTimeB(:,1)== '30-May-2016 16:00:00'));
    time_ix_C = find((RegularPersonTimeC(:,1)== '30-May-2016 16:00:00'));
    % ****** SET DATE END DATETIME (datetime that probes data was
    % downloaded)
    time_ixend_A = find((RegularPersonTimeA(:,1)== '02-Oct-2016 12:00:00'));
    time_ixend_B = find((RegularPersonTimeB(:,1)== '01-Aug-2016 12:00:00'));
    time_ixend_C = find((RegularPersonTimeC(:,1)== '01-Aug-2016 12:00:00'));
    
    Time_trim_A=RegularPersonTimeA(time_ix_A:time_ixend_A);
    Time_trim_B=RegularPersonTimeB(time_ix_B:time_ixend_B);
    Time_trim_C=RegularPersonTimeC(time_ix_C:time_ixend_C);
    
    % Trim TP array to specified datetime indicies 
    TP_A_trim = TP_A(time_ix_A:time_ixend_A ,:);
    TP_B_trim = TP_B(time_ix_B:time_ixend_B ,:);
    TP_C_trim = TP_C(time_ix_C:time_ixend_C ,:);
    
    %Repeat Calibration data to match array of temp data
    Cal_matA = repmat(Cal_all(1, :), size(Time_trim_A, 1), 1);
    Cal_matB = repmat(Cal_all(1, :), size(Time_trim_B, 1), 1);
    Cal_matC = repmat(Cal_all(1, :), size(Time_trim_C, 1), 1);
    
    
% 4. Average Data from 3 temp probes 
    % for loop averages multipile reading/time for each thermister and
    % stores them in array called TP_X_mean.

for i=1:ntherm;
    j=1:length(TP_A_trim);
    TPA_ix = (TP_A_trim(j,i) + TP_A_trim(j,i+6) + TP_A_trim(j,i+12))/3;
    TP_A_mean(j,i)=TPA_ix ; 
end

for i=1:ntherm;
    j=1:length(TP_B_trim);
    TPB_ix = (TP_B_trim(j,i) + TP_B_trim(j,i+6) + TP_B_trim(j,i+12))/3;
    TP_B_mean(j,i)=TPB_ix;
end

for i=1:ntherm;
    j=1:length(TP_C_trim);
    TPC_ix = (TP_C_trim(j,i) + TP_C_trim(j,i+6) + TP_C_trim(j,i+12))/3;
    TP_C_mean(j,i)=TPC_ix;
end

%Calibrate means
    TP_A_meanCAL = TP_A_mean - Cal_matA;
    TP_B_meanCAL = TP_B_mean - Cal_matB;
    TP_C_meanCAL = TP_C_mean - Cal_matC;
    
    
%% 5. PLOT DATA

leg_str = {'30cm', '20cm', '15cm', '10cm', '5cm', '0cm'};
figure
    for i=1:ntherm;
        plot (Time_trim_A, TP_A_meanCAL(:,i))
        hold on
        title TP-A
        ylabel('temp (C)');
        
    end
    legend(leg_str, 'Location', 'NorthEast', 'FontSize', 8);
    print('-dtiff', ['TempA', '.tiff']);
    
    figure
    for i=1:ntherm;
        plot (Time_trim_B, TP_B_meanCAL(:,i))
        hold on
        title TP-B
        ylabel('temp (C)');
      
    end
    legend(leg_str, 'Location', 'NorthEast', 'FontSize', 8);
    print('-dtiff', ['TempB', '.tiff']);
    
    figure
    for i=1:ntherm;
        plot (Time_trim_C, TP_C_meanCAL(:,i))
        hold on
        title TP-C
        ylabel('temp (C)');
        %legend(leg_str, 'Location', 'NorthEast', 'FontSize', 8);
    end
    legend(leg_str, 'Location', 'NorthEast', 'FontSize', 8);
    print('-dtiff', ['TempC', '.tiff']);
    
    
%% 6. Write calibrated and averaged data to .csv

% Find unix time indicies
unix_A = unix_timeA(time_ix_A:time_ixend_A);
unix_B = unix_timeB(time_ix_B:time_ixend_B);
unix_C = unix_timeC(time_ix_C:time_ixend_C);


final_A = horzcat(unix_A, TP_A_meanCAL);
final_B = horzcat(unix_A, TP_A_meanCAL);
final_C = horzcat(unix_A, TP_A_meanCAL);

% .csv files with unix time in first column.
csvwrite('TPA_CalibData_unix.csv',final_A);
csvwrite('TPB_CalibData_unix.csv',final_B);
csvwrite('TPC_CalibData_unix.csv',final_C);

% .csv files with datetime in first column.

    %make tables of datetime and mean,calibrated temp data
Table_A = table([Time_trim_A],[TP_A_meanCAL]);
Table_B = table([Time_trim_B],[TP_B_meanCAL]);
Table_C = table([Time_trim_C],[TP_C_meanCAL]);

writetable (Table_A, 'TPA_CalibData_datetime_20160804.csv')
writetable (Table_B, 'TPB_CalibData_datetime_20160804.csv')
writetable (Table_C, 'TPC_CalibData_datetime_20160804.csv')



    



