clear all
close all
format long g %gets rids of scientific notation

% -temp probe cal files start with bottom probe and move up.
% -each file should have 30 measurements for each thermister (30x6 matrix)
% -

% 0. Save calibration data in an array [A5 A10 A15 A20 B5...]
    CalTemps= [5.084 10.066 15.042 20.027 5.078 10.070 15.046 20.030 5.075 10.066 15.044 20.028]'; 
    
    BathTemp = repmat(CalTemps, 1, 6); %use this for later calcs

% 1. Specify and read temp probe files

    %file identifiers
    SCTempProbe_A_Cal5_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_A_5C_CAL.txt' ;
    SCTempProbe_A_Cal10_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_A_10C_CAL.txt' ;
    SCTempProbe_A_Cal15_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_A_15C_CAL.txt' ;
    SCTempProbe_A_Cal20_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_A_20C_CAL.txt' ;
    
    SCTempProbe_B_Cal5_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_B_5C_CAL.txt' ;
    SCTempProbe_B_Cal10_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_B_10C_CAL.txt' ;
    SCTempProbe_B_Cal15_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_B_15C_CAL.txt' ;
    SCTempProbe_B_Cal20_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_B_20C_CAL.txt' ;
   
    SCTempProbe_C_Cal5_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_C_5C_CAL.txt' ;
    SCTempProbe_C_Cal10_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_C_10C_CAL.txt' ;
    SCTempProbe_C_Cal15_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_C_15C_CAL.txt' ;
    SCTempProbe_C_Cal20_fil = 'C:\Users\Amanda\Desktop\Research\NewTempProbes2016\CalibrationFiles\Probe_C_20C_CAL.txt' ;
    
    %read csv file
    A_Cal5 = csvread(SCTempProbe_A_Cal5_fil);
    A_Cal10 = csvread(SCTempProbe_A_Cal10_fil);
    A_Cal15 = csvread(SCTempProbe_A_Cal15_fil);
    A_Cal20 = csvread(SCTempProbe_A_Cal20_fil);
    
    B_Cal5 = csvread(SCTempProbe_B_Cal5_fil);
    B_Cal10 = csvread(SCTempProbe_B_Cal10_fil);
    B_Cal15 = csvread(SCTempProbe_B_Cal15_fil);
    B_Cal20 = csvread(SCTempProbe_B_Cal20_fil);
    
    C_Cal5 = csvread(SCTempProbe_C_Cal5_fil);
    C_Cal10 = csvread(SCTempProbe_C_Cal10_fil);
    C_Cal15 = csvread(SCTempProbe_C_Cal15_fil);
    C_Cal20 = csvread(SCTempProbe_C_Cal20_fil);
    
%2. put all files together and trim off stupid unix time at the beginning
    AllCal_mat = vertcat(A_Cal5(2:181),A_Cal10(2:181),A_Cal15(2:181),A_Cal20(2:181),...
       B_Cal5(2:181), B_Cal10(2:181), B_Cal15(2:181), B_Cal20(2:181),...
       C_Cal5(2:181), C_Cal10(2:181), C_Cal15(2:181), C_Cal20(2:181));
   
%3. Reshape and average each array to be 30 rows x 6 columns (30 temp reading for each
%thermister)
       A5 = reshape(A_Cal5(2:181),[],6);
       A10 = reshape(A_Cal10(2:181),[],6);
       A15 = reshape(A_Cal15(2:181),[],6);
       A20 = reshape(A_Cal20(2:181),[],6);
       B5 = reshape(B_Cal5(2:181),[],6);
       B10 = reshape(B_Cal10(2:181),[],6);
       B15 = reshape(B_Cal15(2:181),[],6);
       B20 = reshape(B_Cal20(2:181),[],6);
       C5 = reshape(C_Cal5(2:181),[],6);
       C10 = reshape(C_Cal10(2:181),[],6);
       C15 = reshape(C_Cal15(2:181),[],6);
       C20 = reshape(C_Cal20(2:181),[],6);
       
      %put all reshaped variables into one array (12x6 array)
       ReshapedMean = vertcat(mean(A5), mean(A10), mean(A15), mean(A20),...
           mean(B5), mean(B10), mean(B15), mean(B20), mean(C5), mean(C10),...
           mean(C15), mean(C20));
     
%4. Compare with calibration data recorded by thermocouple in Scott's water
%bath.

   %difference between thermister readings (ResphaedMeans) and
   %thermocouple reading in bath (BathTemp)
     CalDiff = (ReshapedMean - BathTemp); 
     
   %Need to average the differences (CalDiff) for each thermister, which
   %means averaging multiple temperatures. 
     CalDiffA = vertcat(CalDiff(1, :), CalDiff(2, :), CalDiff(3, :), CalDiff(4,:));
     CalDiffB = vertcat(CalDiff(5, :), CalDiff(6, :), CalDiff(7, :), CalDiff(8,:));
     CalDiffC = vertcat(CalDiff(9, :), CalDiff(10, :), CalDiff(11, :), CalDiff(12,:));
     
     
     %Array of correction data. All values are positive, which means that
     %the thermisters read a little high, so we have to subract this amount
     %from every thermister reading.
     MeanCalDiffAll = vertcat(mean(CalDiffA), mean(CalDiffB), mean(CalDiffC));
     
   %Write correction to file 
       csvwrite('TempProbCalAvg_2016.dat',MeanCalDiffAll)
       
       

        

    
    