tenminIntervals = load('C:\SecondCreekGit\Scripts\PZ-In_161005_Calib20161001_1300_results.mat');
%will interpolate times and pressures seprate, then put back together.
%code from https://www.mathworks.com/matlabcentral/answers/136870-converting-resampling-10-min-interval-timseries-data-to-15-min
t_10 = datenum(tenminIntervals.DivDateTime); 

n_10 = length(t_10);

n_15 = n_10 * 2 / 3;

t_15(1:2:n_15) = (t_10(1:3:n_10) * 2 + t_10(2:3:n_10)) / 3;

t_15(2:2:n_15) = (t_10(2:3:n_10) + t_10(3:3:n_10) * 2) / 3;

t_15 = datestr(t_15, 'mm/dd/yyyy HH:MM');


h_10 = tenminIntervals.DivTotHead; 

n_10 = length(h_10);

n_15 = n_10 * 2 / 3;

h_15(1:2:n_15) = (h_10(1:3:n_10) * 2 + h_10(2:3:n_10)) / 3;

h_15(2:2:n_15) = (h_10(2:3:n_10) + h_10(3:3:n_10) * 2) / 3;



 
fileID = fopen('C:\SecondCreekGit\TempProbeAnalysis\PZIN_interpolated.csv','w');
 [nrows, ncols] = size(h_15) ;


for row = 1:nrows
   
   fprintf(fileID, '%s%s%f\r\n', t_15{row,1} , ', ', h_15(row,1));
end