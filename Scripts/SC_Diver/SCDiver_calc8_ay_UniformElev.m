%Outputs head difference in cm

% SCDiver_calc7.m 
%
% This script does the folloing:
% - Can do for each Diver...
% - Reads in pressure tranducer data and barologger time series data
% - Calculates pressure head by subtracting out atmospheric pressure
% - Plots pressure head over time
% - Uses manual depth-to-water measurement inside PVC piezometer at 
%   specified time to determine pressure tranducer elevation (above sea 
%   level)
% - Prints out pressure tranducer elevation 
% - Calculates, plots, and prints total head over time
% - Saves date/time, pressure head, total head, and temperatures in .mat
%   file
%
% Script development notes:
% - 6/26/15 (gcng): created script and ran it for SG-1, PZ-In, PZ-Out, and 
%   PZ-Bank
% - v3 (8/9/15): small modifications to process July data (mostly label
%   dates and added comments).
%   - 8/27/15: change file names to include calibration date and time
%     (i.e., date/time of manual depth-to-water measurement) 
% - added 2016 data

% version 8: 
%   -AY made all the diver elevations consistent between collection times for 2015 data
%    only (this still needs to be done for 2016 data).
%   -AY entered and double checked the 2016 survey elevations into the 2016 data
%    (see Elev_LatLon_2016.xls for 2016 survey data)
%   -AY 2016 DivStart/EndTime/Date still needs to be entered!!!!


clear all, close all, fclose all;

% - Choose one data file by download date 
% date_label = '150625';
% date_label = '150709';
% date_label = '150812';
%date_label = '151016'
% date_label = '160530';
  date_label = '161005';

% - Choose one transducer
% DivLabel = 'test';
 DivLabel = 'PZ-In';
% DivLabel = 'PZ-Out';
% DivLabel = 'PZ-Bank';
% DivLabel = 'PZ-CW'; %added summer 2016
% DivLabel = 'PZ-CC'; %added summer 2016
% DivLabel = 'PZ-CE'; %added summer 2016
% DivLabel = 'PZ-E';
% DivLabel = 'A2';
% DivLabel = 'B1';
% DivLabel = 'C1';
% DivLabel = 'D1';
% DivLabel = 'E1';

% =========================
% 6/25/15
% =========================



if strcmp(date_label, '161005')
% date_label = '160530';

    DivEndDate = nan; DivEndTime = nan;  % nan: use end of file
    if strcmp(DivLabel, 'SG-1') 
  
     % ****ACTUALLY SG1_2 because SG1 was moved partway through the summer!
       
        PVC_Elev = 428.818 * 100; % m -> cm [total station transit 10/01/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSVedit\sg1_4_161005161403_H2366_edit.CSV'; % clipped out some data 6/25/15
%         ManualDate = '2015/06/25'; ManualTime = '16:30:00'; PVC_DepthToWater = 75; % cm
%         ManualDate = '2015/07/10'; ManualTime = '09:30:00'; PVC_DepthToWater = 88.7; % cm
        ManualDate = '2016/10/16'; ManualTime = '18:00:00'; PVC_DepthToWater = 102.2; % cm
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2016/08/13'; DivStartTime = '14:50:00';  % nan: use top of file
        DivEndDate = '2016/10/16'; DivEndTime = '17:50:00';  % nan: use end of file

    % *********************

    elseif strcmp(DivLabel, 'PZ-In') 
        PVC_Elev = 429.098 * 100; % m -> cm [total station transit 10/01/16]
        SCDiver_fil = 'C:\SecondCreekGit\DATA\2016_head_data\2016_10_02\CSV_edit\pzi_6_161005160841_M9505.CSV';
%         ManualDate = '2015/07/10'; ManualTime = '09:20:00'; PVC_DepthToWater = 45.09; % cm
%         ManualDate = '2015/07/10'; ManualTime = '15:30:00'; PVC_DepthToWater = 45.72; % cm
        ManualDate = '2015/10/16'; ManualTime = '16:20:00'; PVC_DepthToWater = 61.2; % cm
        Div_Int_Min = 15; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '14:50:00';  % nan: use top of file
        DivEndDate = '2015/10/16'; DivEndTime = '16:20:00';  % nan: use end of file

    elseif strcmp(DivLabel, 'PZ-Out')
        PVC_Elev = 429.12 * 100; % m -> cm [total station transit 10/02/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSV\pzo_1_161005162522_J3542.CSV';
%         ManualDate = '2015/07/10'; ManualTime = '09:40:00'; PVC_DepthToWater = 45.09; % cm
%         ManualDate = '2015/07/10'; ManualTime = '15:30:00'; PVC_DepthToWater = 46.99; % cm
        ManualDate = '2015/10/16'; ManualTime = '16:40:00'; PVC_DepthToWater = 59; % cm (DO NOT TRUST BC FLOODED AND BUBBLES WHEN CAP REMOVED)  
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '15:10:00';  % nan: use top of file
        DivEndDate = '2015/10/16'; DivEndTime = '16:40:00';  % nan: use end of file

    elseif strcmp(DivLabel, 'PZ-Bank')
        PVC_Elev = 430.288 * 100; % m -> cm [total station transit 10/02/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSV\pzb_5_161005162131_J3507.CSV';
%         ManualDate = '2015/07/10'; ManualTime = '15:30:00'; PVC_DepthToWater = 47.68; % cm
        ManualDate = '2015/10/16'; ManualTime = '12:00:00'; PVC_DepthToWater = 50.1; % cm
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '14:30:00'; % nan: use start of file
        DivEndDate = '2015/10/16'; DivEndTime = '12:00:00';  % nan: use end of file

    elseif strcmp(DivLabel, 'PZ-E')
        PVC_Elev = 429.538 * 100; % m -> cm [total station transit 10/02/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSV\pze_7_161005155935_M9447.CSV';
        ManualDate = '2015/10/16'; ManualTime = '14:50:00'; PVC_DepthToWater = 101.1; % cm
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '18:50:00'; % nan: use start of file
        DivEndDate = '2015/10/16'; DivEndTime = '14:50:00';  % nan: use end of file

    elseif strcmp(DivLabel, 'PZ-CW') %Channel West
        PVC_Elev = 429.212 * 100; % m -> cm [total station transit 10/01/16 and 10/02/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSV\pzcw_8_161005160252_M9440.CSV';
        ManualDate = '2015/10/16'; ManualTime = '14:50:00'; PVC_DepthToWater = 101.1; % cm
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '18:50:00'; % nan: use start of file
        DivEndDate = '2015/10/16'; DivEndTime = '14:50:00';  % nan: use end of file
        
    elseif strcmp(DivLabel, 'PZ-CC') %Channel Center
        PVC_Elev = 429.563 * 100; % m -> cm [total station transit averaged 10/01/16 and 10/02/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSV\pzcc_3_161005155030_M9438.CSV';
        ManualDate = '2015/10/16'; ManualTime = '14:50:00'; PVC_DepthToWater = 101.1; % cm
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '18:50:00'; % nan: use start of file
        DivEndDate = '2015/10/16'; DivEndTime = '14:50:00';  % nan: use end of file
        
    elseif strcmp(DivLabel, 'PZ-CE') %Channel East
        PVC_Elev = 429.342 * 100; % m -> cm [total station transit averaged 10/01/16 and 10/02/16]
        SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_10_02\CSV\pzcw_8_161005160252_M9440.CSV';
        ManualDate = '2015/10/16'; ManualTime = '14:50:00'; PVC_DepthToWater = 101.1; % cm
        Div_Int_Min = 10; % time interval in min
        DivStartDate = '2015/08/13'; DivStartTime = '18:50:00'; % nan: use start of file
        DivEndDate = '2015/10/16'; DivEndTime = '14:50:00';  % nan: use end of file
        
%     elseif strcmp(DivLabel, 'A2')
%         PVC_Elev = 431.638 * 100; % m -> cm [level transit]
%         SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_05_30\CSV_edit\A2_160530download_data.csv';
% %         ManualDate = '2015/07/10'; ManualTime = '16:30:00'; PVC_DepthToWater = 8.82*12*2.54; % cm, corresp to end of y-stick venting
%         ManualDate = '2016/05/30'; ManualTime = '19:00:00'; PVC_DepthToWater = 8.25*12*2.54; % cm, corresp to end of y-stick venting
%         Div_Int_Min = 15; % time interval in min
%         DivStartDate = '2015/10/17'; DivStartTime = '17:00:00'; % nan: use start of file
%         DivEndDate = '2016/05/30'; DivEndTime = '19:00:00';  % nan: use end of file
% 
%     elseif strcmp(DivLabel, 'B1')
%         PVC_Elev = 431.083 * 100; % m -> cm [level transit]
%         SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_05_30\CSV_edit\B1_160530downlaod_data.csv'; % clipped out some 7/10 data (diver removed temporarily?)
% %         ManualDate = '2015/07/10'; ManualTime = '11:20:00'; PVC_DepthToWater = 7.04*12*2.54; % cm, corresp to end of y-stick venting
%         ManualDate = '2016/05/30'; ManualTime = '19:00:00'; PVC_DepthToWater = 6.51*12*2.54; % cm, corresp to end of y-stick venting
%         Div_Int_Min = 15; % time interval in min
%         DivStartDate = '2015/10/17'; DivStartTime = '17:00:00'; % nan: use start of file
%         DivEndDate = '2016/05/30'; DivEndTime = '19:00:00';  % nan: use end of file
% 
%     elseif strcmp(DivLabel, 'C1')
%         PVC_Elev = 431.348 * 100; % m -> cm [level transit]
%         SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_05_30\CSV_edit\C1_160530download_data.csv'; % clipped out some 7/10 data (diver removed temporarily?)
% %         ManualDate = '2015/07/10'; ManualTime = '11:30:00'; PVC_DepthToWater = 7.32*12*2.54; % cm, corresp to end of y-stick venting
%         ManualDate = '2016/05/30'; ManualTime = '19:00:00'; PVC_DepthToWater = 6.52*12*2.54; % cm, corresp to end of y-stick venting
%         Div_Int_Min = 15; % time interval in min
%         DivStartDate = '2015/10/17'; DivStartTime = '17:00:00'; % nan: use start of file
%         DivEndDate = '2016/05/30'; DivEndTime = '19:00:00';  % nan: use end of file
% 
%     elseif strcmp(DivLabel, 'D1')
%         PVC_Elev = 432.476 * 100; % m -> cm [level transit]
%         SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_05_30\CSV_edit\D1_160530download_data.csv'; % clipped out some 7/10 data (diver removed temporarily?)
% %         ManualDate = '2015/07/10'; ManualTime = '12:10:00'; PVC_DepthToWater = 10.68*12*2.54; % cm
%         ManualDate = '2016/05/30'; ManualTime = '19:15:00'; PVC_DepthToWater = 9*12*2.54; % cm
% %         ManualDate = '2015/08/12'; ManualTime = '19:20:00'; PVC_DepthToWater = 9.98*12*2.54; % cm
%         Div_Int_Min = 15; % time interval in min
%         DivStartDate = '2015/10/17'; DivStartTime = '17:00:00'; % nan: use start of file
%         DivEndDate = '2016/05/30'; DivEndTime = '19:15:00';  % nan: use end of file
% 
%     elseif strcmp(DivLabel, 'E1')
%         PVC_Elev = 429.903 * 100; % m -> cm [level transit 10/17]
%         SCDiver_fil = 'C:\Users\Amanda\Desktop\Research\Diver\2016_05_30\CSV_edit\E1_160530download_data.csv'; 
% %         ManualDate = '2015/07/10'; ManualTime = '16:40:00'; PVC_DepthToWater = 5.36*12*2.54; % cm, corresp to end of y-stick venting
%         ManualDate = '2016/05/30'; ManualTime = '19:30:00'; PVC_DepthToWater = 4.69*12*2.54; % cm, corresp to end of y-stick venting
%         Div_Int_Min = 15; % time interval in min
%         DivStartDate = '2015/10/17'; DivStartTime = '17:00:00'; % nan: use start of file
%         DivEndDate = '2016/05/30'; DivEndTime = '19:30:00';  % nan: use end of file
    else
        fprintf('No data file for %s; exiting... \n', date_label);
        return
    end

    % *********************

    SCBaro_fil = 'C:\SecondCreekGit\DATA\2016_head_data\2016_10_02\CSV_edit\a2_baro_161005161148_M9484.csv';
    Baro_Int_Min = 15; % time interval in min
        
end
%% ========================================================================

% read files
fid = fopen(SCDiver_fil, 'r');
DDiv = textscan(fid, '%s%s%f%f', 'Delimiter', {' ', ','});
fclose(fid);

fid = fopen(SCBaro_fil, 'r');
DBar = textscan(fid, '%s%s%f%f', 'Delimiter', {' ', ','});
fclose(fid);

% get matching dates
if isnan(DivStartDate)
    Div_ind1 = 1;
else
    Div_ind1 = find(strcmp(DDiv{1}, DivStartDate) & strcmp(DDiv{2}, DivStartTime));
end
while(1)
    Bar_ind1 = find(strcmp(DDiv{1}(Div_ind1), DBar{1}) & strcmp(DDiv{2}(Div_ind1), DBar{2}),1);
    if isempty(Bar_ind1)
        Bar_ind1 = 1;
        Div_ind1 = find(strcmp(DBar{1}(Bar_ind1), DDiv{1}) & strcmp(DBar{2}(Bar_ind1), DDiv{2}),1);
        stuck = 'we are stuuuuck'
    end
    if isempty(Div_ind1)
        Div_ind1 = Div_ind1 + 1; % try another time
        if Div_ind1 == 0                
            fprintf('Error, do Diver and Baro have same time interval (1)? exiting...\n');
            return
        end
    else
        break
    end
end

if isnan(DivEndDate)
    Div_ind2_0 = length(DDiv{1});
else
    Div_ind2_0 = find(strcmp(DDiv{1}, DivEndDate) & strcmp(DDiv{2}, DivEndTime));
end
count = 0;
while(1)
     Div_ind2 = length(DDiv{1}) - count;
    Div_ind2 = Div_ind2_0 - count;
    Bar_ind2 = find(strcmp(DDiv{1}(Div_ind2), DBar{1}) & strcmp(DDiv{2}(Div_ind2), DBar{2}),1);
    if isempty(Bar_ind2)
        Bar_ind2 = length(DBar{1}) - count;
        Div_ind2 = find(strcmp(DBar{1}(Bar_ind2), DDiv{1}) & strcmp(DBar{2}(Bar_ind2), DDiv{2}),1);
    end
    if ~isempty(Div_ind2)
        break,
    else
        if Div_ind2 == 0
            fprintf('Error, do Diver and Baro have same time interval (2)? exiting...\n');
            return
        end
    end
    count = count + 1;
end

DivDate = DDiv{1}(Div_ind1:Div_ind2); % 
DivTime = DDiv{2}(Div_ind1:Div_ind2); % 
DivPress = DDiv{3}(Div_ind1:Div_ind2); % cm
DivTemp = DDiv{4}(Div_ind1:Div_ind2); % C
BarPress = DBar{3}(Bar_ind1:Bar_ind2); % cm
BarTemp = DBar{4}(Bar_ind1:Bar_ind2); % C

% correct for mismatched time interval, interp BarTemp
Bar_time_orig = [0:Baro_Int_Min:Baro_Int_Min*(length(BarPress)-1)]';
Bar_time_new = [0:Div_Int_Min:Div_Int_Min*(length(DivPress)-1)]';
BarPress = interp1(Bar_time_orig, BarPress, Bar_time_new);
BarTemp = interp1(Bar_time_orig, BarTemp, Bar_time_new);

% time
DivDateTime = [cell2mat(DivDate), repmat(' ', size(DivDate,1), 1), cell2mat(DivTime)];
DivDateTime_num = datenum(DivDateTime);

% correct atmos pressure
DivPress_compensated = DivPress - BarPress;  % cm

% plot

time_d = [0:length(DivPress_compensated)-1] * Div_Int_Min / (60*24);

subplot(2,1,1),
% plot(time_d, DivPress), title('Diver press [cm]');
% xlabel('time [d]');
plot(DivDateTime_num, DivPress), title('Diver press [cm]');
datetick('x', 6);

subplot(2,1,2),
plot(DivDateTime_num, BarPress), title('Baro press [cm]');
datetick('x', 6);


% get DiverDepth (down from top of PVC) and DiverElev [cm]
ind_end = find(strcmp(ManualDate, DivDate) & strcmp(ManualTime, DivTime));
DiverDepth = PVC_DepthToWater + DivPress_compensated(ind_end);
%DiverElev = PVC_Elev - DiverDepth; % cm
print DiverDepth

% general filename
a  = ManualDate([1:4, 6:7, 9:10]);
b = ManualTime([1:2, 4:5]);
filename0 = [DivLabel, '_', date_label, '_Calib', a, '_', b];

figure(2)
% subplot(3,1,3),
plot(DivDateTime_num, DivPress_compensated), 
title(DivLabel);
ylabel('Compensated Press [cm]');
datetick('x', 6);
figname = [filename0, '_CompPress.tiff'];
print('-dtiff', figname);

filname = [filename0, '_CalibResult.txt'];
for ii = 1:2
    if ii == 1,
        fid = 1;
    elseif ii == 2
        fid = fopen(filname, 'wt');
    end
    fprintf(fid, '----------------------------------------------\n');
    fprintf(fid, '%s on %s, %s: \n', DivLabel, ManualDate, ManualTime);
    fprintf(fid, '   Manual Depth to Water: %10.6f m (%g ft)\n', PVC_DepthToWater/100, PVC_DepthToWater/2.54/12);
    fprintf(fid, '   TOC Elev: %10.6f m (%g ft)\n', PVC_Elev/100, PVC_Elev/2.54/12);
    fprintf(fid, '   Diver Elev: %10.6f m (%g ft)\n', DiverElev/100, DiverElev/2.54/12);
    fprintf(fid, '   Diver TotHead: %10.6f m (%g ft)\n', (DiverElev+DivPress_compensated(ind_end))/100, (DiverElev+DivPress_compensated(ind_end))/2.54/12);
    fprintf(fid, '----------------------------------------------\n\n');
end
fclose(fid);

% get TotHead
TotHead = DivPress_compensated + DiverElev; % cm
figure(3)
% subplot(3,1,3),
plot(DivDateTime_num, TotHead/100), 
title(DivLabel);
ylabel('TotHead [m asl]');
datetick('x', 6);
xtickv = get(gca,'XTick');
xlimv = get(gca,'XLim');
figname = [filename0 '_TotHead.tiff'];
print('-dtiff', figname);

filname = [filename0, '_TotHead.txt'];
for ii = 2:2
    if ii == 1,
        fid = 1;
    elseif ii == 2
        fid = fopen(filname, 'wt');
    end
    a = cell2mat(DivDate); b = cell2mat(DivTime);
    fprintf(fid, '----------------------------------------------\n');
    fprintf(fid, '%s TotHead [m]: \n', DivLabel);
    for jj = 1: length(DivPress_compensated)
        fprintf(fid, '    %s %s %10.6f \n', a(jj,:), b(jj,:)', (DiverElev+DivPress_compensated(jj))/100);
    end
    fprintf(fid, '----------------------------------------------\n\n');
end
fclose(fid);

filname = [filename0, '_results'];
DivTotHead = DiverElev+DivPress_compensated; % cm
save(filname, 'DivLabel', 'DivDateTime', 'DivPress_compensated', 'DivTotHead', 'DivTemp');

%% ------------------------------------------------------------------------
% PLOT PRECIP DATA
% 
% infile = 'C:\Users\Amanda\Desktop\Research\Scripts\diver\Weather_EmbarrassMN_150501_151016.csv';
% 
% fid = fopen(infile, 'r');
% for ii = 1: 8, line = fgets(fid); end  % remove header lines
% % return
% D = textscan(fid, '%s%s%s%s%s%s', 'Delimiter', {' ', ','});
% fclose(fid);
% 
% 
% fprintf('Setting trace to 0, missing data to nan...\n');
% 
% for loop = 1:5
%     a = D{loop+1};
%     b = nan(length(a),1);
%     for ii = 1: length(a)
%         if strcmp(D{1}{ii}, 'Sum:')
%             N = ii-1;
%             break
%         end
%         if strcmp(a{ii}, 'T')
%             b(ii) = 0;
%         elseif ~strcmp(a{ii}, 'M')
%             b(ii) = str2double(a{ii});
%         end    
%     end
%     switch loop
%         case 1, precip_in = b(1:N);
%         case 2, snowfall_in = b(1:N);
%         case 3, snowdepth_in = b(1:N);
%         case 4, maxT_F = b(1:N);
%         case 5, minT_in = b(1:N);
%     end
% end
% datestr_v = D{1}(1:N);
% 
% datenum_v = datenum(datestr_v);
% 
% figure(1), orient landscape
% subplot(3,1,1)
% plot(datenum_v, precip_in), 
% title('Daily precip (in)');
% datetick('x',6);
% set(gca,'XTick', xtickv, 'XLim', xlimv);
