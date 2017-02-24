%Script to determine if theere are non-numeric entries in the 1D TempProbe
%data file

CheckFile = 'C:\SecondCreekGit\TempProbeAnalysis\TPA_CalibData_1DTempPro.csv';
File_A = csvread(CheckFile,1,1);

 [rows columns] = size(File_A)


sum (File_A < 0)


if isnumeric(File_A)
    disp('numbers')
else 
    disp('not')
end

% lets try rounding the values
File_A = round(File_A *100)/100;

% for i=1:rows;
%     for j=1:columns:
%         