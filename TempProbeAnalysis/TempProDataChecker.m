%Script to determine if theere are non-numeric entries in the 1D TempProbe
%data file.  

CheckFile = 'C:\SecondCreekGit\TempProbeAnalysis\TPA_CalibData_1DTempPro.csv';
File_A = csvread(CheckFile,1,1);



 sum (File_A, 'includenan' )%If these two sums are the same, the file should be good
 sum (File_A, 'omitnan' )

sum(isnan(File_A)) %If this is zero, file should be good to go
    