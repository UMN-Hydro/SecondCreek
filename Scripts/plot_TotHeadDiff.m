% plot_TotHead.m
%
% This script does the folloing:
% - Loops through final results (processed with SCDiver_calc2.m) and plots
%   Total Head results together.
%
% Script development notes:
% - 6/26/15 (gcng): created script and ran it for SG-1, PZ-In, PZ-Out, and 
%   PZ-Bank
% - v2 (8/12/15): reads in multiple files, including piezometers and wells
% - v3 (8/27/15): also plots precip data


clear all, close all, fclose all;

% % == 7/9/15 =========================================================
% % save to this figure name
% figname = 'All_TotHead_150709download.tiff';
% 
% nsites_max = 11;
% nfiles_max = 6;
% fil = cell(nsites_max, nfiles_max);
% sitename = cell(nsites_max,1);  
% sitetype = cell(nsites_max,1);
% ii = 0; 
% ii = ii+1; jj = 0; sitename{ii} = 'SG1'; sitetype{ii} = 'S';
% jj = jj+1; fil{ii,jj} = 'SG-1_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'PZI'; sitetype{ii} = 'P';
% jj = jj+1; fil{ii,jj} = 'PZ-In_results.mat';
% jj = jj+1; fil{ii,jj} = 'PZ-In_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'PZO'; sitetype{ii} = 'P';
% jj = jj+1; fil{ii,jj} = 'PZ-Out_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'PZB'; sitetype{ii} = 'P';
% jj = jj+1; fil{ii,jj} = 'PZ-Bank_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'A2'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = 'A2_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'B1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = 'B1_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'C1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = 'C1_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'D1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = 'D1_150709_results.mat';
% ii = ii+1; jj = 0; sitename{ii} = 'E1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = 'E1_150709_results.mat';
% nsites = ii;
% % ===================================================================

% == 8/12/15 =========================================================
% NOTE: 150812 total head files were chosen based on checking results with
% the various manual depth-to-water calibration measurements.  See
% /home/gcng/workspace/matlab_files/SecondCreek/Calib_all_150812.txt
% (probably best to compare back with Diver Elev found in previous months)

% Amanda:
% dir0 = 'C:\Users\Amanda\Desktop\Research\Scripts\diver\';
 
% Crystal
%dir0 = '/home/gcng/workspace/matlab_files/SecondCreek/PressTransResults/';

%Jack, git
dir0='C:\SecondCreekGit\Scripts\';




%2016
% save to this figure name
figname = 'All_TotHead_161005download.tiff';

nsites_max = 11;
nfiles_max = 6;
fil = cell(nsites_max, nfiles_max);
sitename = cell(nsites_max,1);  
sitetype = cell(nsites_max,1);
ii = 0; 

%using first placment of SG-1
ii = ii+1; jj = 0; sitename{ii} = 'SG1'; sitetype{ii} = 'G';
jj = jj+1; fil{ii,jj} = [dir0, 'SG-1_1st_Position_161005_Calib20160531_1030_results.mat'];
 jj = jj+1; fil{ii,jj} = [dir0, 'SG-1_2nd_Position_161005_Calib20161001_1430_results.mat'];
% jj = jj+1; fil{ii,jj} = [dir0, 'SG-1_151016_Calib20151016_1740_results.mat'];


ii = ii+1; jj = 0; sitename{ii} = 'PZCC'; sitetype{ii} = 'P';
%jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Bank_150709_results.mat'];
jj = jj+1; fil{ii,jj} = [dir0, 'PZ-CC_161005_Calib20161001_1300_results.mat'];



% ii = ii+1; jj = 0; sitename{ii} = 'PZB'; sitetype{ii} = 'P';
% %jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Bank_150709_results.mat'];
% jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Bank_161005_Calib20161002_1245_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Bank_150812_Calib20150812_1840_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Bank_151016_Calib20151016_1200_results.mat'];
% 
% ii = ii+1; jj = 0; sitename{ii} = 'PZ-E'; sitetype{ii} = 'P';
% jj = jj+1; fil{ii,jj} = [dir0, 'PZ-E_161005_Calib20161001_1400_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-E_151016_Calib20151016_1450_results.mat'];
% 
% ii = ii+1; jj = 0; sitename{ii} = 'PZI'; sitetype{ii} = 'P';
% jj = jj+1; fil{ii,jj} = [dir0, 'PZ-In_161005_Calib20161001_1300_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-In_150709_Calib20150709_1400_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-In_150812_Calib20150812_1900_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-In_151016_Calib20151016_1620_results.mat'];
% 
% ii = ii+1; jj = 0; sitename{ii} = 'PZO'; sitetype{ii} = 'P';
% %jj = jj+1; fil{ii,jj} =
% %[dir0, 'PZ-Out_150625_Calib20150625_1620_results.mat'];
% %don't need - creates a double line b/c data is on 150709
% jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Out_161005_Calib20161001_1545_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Out_150812_Calib20150812_1910_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'PZ-Out_151016_Calib20151016_1640_results.mat'];
% % 
% ii = ii+1; jj = 0; sitename{ii} = 'E1'; sitetype{ii} = 'G';
% % jj = jj+1; fil{ii,jj} = [dir0, 'E1_150709_Calib20150626_1320_results.mat'];
% jj = jj+1; fil{ii,jj} = [dir0, 'E1_160530_Calib20160530_1930_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'E1_151016_Calib20151016_1200_results.mat'];
% 
% ii = ii+1; jj = 0; sitename{ii} = 'A2'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = [dir0, 'A2_160530_Calib20160530_1900_results.mat'];
% %jj = jj+1; fil{ii,jj} = [dir0, 'A2_150812_Calib20150812_1810_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'A2_151016_Calib20151016_1200_results.mat'];
% 
% 
% ii = ii+1; jj = 0; sitename{ii} = 'B1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = [dir0, 'B1_160530_Calib20160530_1900_results.mat'];
% %jj = jj+1; fil{ii,jj} = [dir0, 'B1_150812_Calib20150812_1800_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'B1_151016_Calib20151016_1200_results.mat'];
% 
% ii = ii+1; jj = 0; sitename{ii} = 'C1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = [dir0, 'C1_160530_Calib20160530_1900_results'];
% %jj = jj+1; fil{ii,jj} = [dir0, 'C1_150812_Calib20150812_1700_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'C1_151016_Calib20151016_1200_results.mat'];
% 
% ii = ii+1; jj = 0; sitename{ii} = 'D1'; sitetype{ii} = 'G';
% jj = jj+1; fil{ii,jj} = [dir0, 'D1_160530_Calib20160530_1915_results'];
% %jj = jj+1; fil{ii,jj} = [dir0, 'D1_150812_Calib20150710_1630_results.mat'];
% % jj = jj+1; fil{ii,jj} = [dir0, 'D1_151016_Calib20151016_1200_results.mat'];


nsites = ii;
sitename = sitename(1:nsites);
% ===================================================================
leg = cell(nsites,1);
h = zeros(nsites,1); 

a=[1:10];
cmap = hsv(length(a));

% clr_str1 = {cmap(1:1,:)}; % stream
% clr_str2 = {cmap(2:5,:)}; % pz
% clr_str3 = {cmap(6:9,:)};  % well


clr_str1 = {'b'};
clr_str2 = {'r', 'k', 'g', 'm'};
clr_str3 = {'b', 'c', 'k', 'r', 'm'};
%  

% colors for presentations
% clr_str1 = {'b'};
% clr_str2 = {'k', 'k', 'k', 'k'};
% clr_str3 = {'r', 'k', 'k', 'k', 'k'};
 
% different lines for different types of sites
ctr = 0;
figure(1), orient landscape
subplot(3,1,[1:2]);
for tt = 3
    switch tt
        case 1 % SW
            LW = 3;
            linestr = ':*';
            ind = find(strcmp(sitetype, 'S'));
            clr_str = clr_str1;
        case 2 % PW
            LW = 2;
            linestr = '--';
            ind = find(strcmp(sitetype, 'P'));
            clr_str = clr_str2;
        case 3 % GW
            LW = 2;
            linestr = '-';
            ind = find(strcmp(sitetype, 'G'));
            clr_str = clr_str3;
    end
    
    ctr2 = 0;

    indSG = find(strcmp(sitename, 'SG1'));
    datenumSG = nan(365*24*60,1); % initialize bigger than needed
    DivTotHeadSG = nan(365*24*60,1); % initialize bigger than needed
    ctrSG = 0;
    for ii = indSG; % SG
         ctr = ctr+1;
         ctr2 = ctr2+1;
        for jj = 1: nfiles_max
            if isempty(fil{ii,jj})
                break,
            end            
            
            % load data
            d = load(fil{ii,jj});

            % concatenate all SG data
            datenumSG(ctrSG+[1:length(d.DivDateTime)]) = datenum(d.DivDateTime);
            DivTotHeadSG(ctrSG+[1:length(d.DivDateTime)]) = d.DivTotHead;
            
            ctrSG = ctrSG + length(d.DivDateTime);
        end
    end
    datenumSG = datenumSG(1:ctrSG);
    DivTotHeadSG = DivTotHeadSG(1:ctrSG);
    
    % make sure in increasing time order
    [datenumSG, ind] = sort(datenumSG, 'ascend');
    DivTotHeadSG = DivTotHeadSG(ind);
    
    % remove repeat dates
    [datenumSG, ind, ~] = unique(datenumSG);
    DivTotHeadSG = DivTotHeadSG(ind);
    
    indNotSG = find(~strcmp(sitename, 'SG1'));
    for ii = indNotSG(:)'
        ctr = ctr+1;
        ctr2 = ctr2+1;
        for jj = 1: nfiles_max
            if isempty(fil{ii,jj})
                break,
            end            
            
            % load data
            d = load(fil{ii,jj});
            datenum0 = datenum(d.DivDateTime);
            
            % calculate differences from stream head (SG1)
            DivTotHeadSG0 = interp1(datenumSG, DivTotHeadSG, datenum0);
            TotHeadDiff = (d.DivTotHead-DivTotHeadSG0)/100;
            
        
            % plot data
            plotsym = [linestr, clr_str{ctr2}];
            h0 = plot(datenum0, TotHeadDiff, plotsym, 'LineWidth', LW);
            hold on
        end
        h(ctr) = h0;
        leg{ctr} = sitename{ii};    
    end
end
h = h(1:ctr);
leg = leg(1:ctr);
ylabel('Tot Head Diff [m asl]');

ymd1 = [2015 6 1; ...
       2015 6 10; ...
       2015 6 20; ...
       2015 7 1; ...
       2015 7 10; ...
       2015 7 20; ...
       2015 8 1; ...
       2015 8 10; ...
       2015 8 20; ...
       2015 9 1;...
       2015 9 10;...
       2015 9 20;...
       2015 10 1;...
       2015 11 1;...
       2015 12 1;...
       2016 1 1;...
       2016 2 1;...
       2016 3 1;...
       2016 4 1;...
       2016 5 1;...
       2016 6 1]; 

ymd = [2015 6 1; ...
       2015 7 1; ...
      2015 8 1; ...
       2015 9 1;...
      2015 10 1;...
       2015 11 1;...
       2015 12 1;...
       2016 1 1;...
       2016 2 1;...
       2016 3 1;...
       2016 4 1;...
       2016 5 1;...
       2016 6 1]; 
       
   
y = ymd(:,1); m = ymd(:,2); d = ymd(:,3); 
xtickv = datenum(y, m, d);
xticklabv = cell(length(y),1);
for ii = 1: length(y)
    xticklabv{ii} = [num2str(m(ii)), '/', num2str(d(ii)),];
end
set(gca,'XLim', xtickv([1, end]), 'XTick', xtickv, 'XTickLabel', xticklabv, 'FontSize', 18);

datetick('x', 6);
legend(h, leg, 'Location', 'SouthWest');
axis tight
grid on

ax1 = gca;

title('Head difference from surface water');

return
%% ------------------------------------------------------------------------

infile = [dir0, 'Weather_EmbarrassMN_151017_161005.csv'];

fid = fopen(infile, 'r');
for ii = 1: 8, line = fgets(fid); end  % remove header lines
% return
D = textscan(fid, '%s%s%s%s%s%s', 'Delimiter', {' ', ','});
fclose(fid);


fprintf('Setting trace to 0, missing data to nan...\n');

for loop = 1:5
    a = D{loop+1};
    b = nan(length(a),1);
    TF_miss = zeros(length(a), 1);
    for ii = 1: length(a)
        if strcmp(D{1}{ii}, 'Sum:')
            N = ii-1;
            break
        end
        if strcmp(a{ii}, 'T')
            b(ii) = 0;
        elseif ~strcmp(a{ii}, 'M')
            b(ii) = str2double(a{ii});
        else
            TF_miss(ii) = 1;  % 1 if missing data
        end    
    end
    switch loop
        case 1, precip_in = b(1:N); precip_TF_miss = TF_miss(1:N);
        case 2, snowfall_in = b(1:N);
        case 3, snowdepth_in = b(1:N);
        case 4, maxT_F = b(1:N);
        case 5, minT_in = b(1:N);
    end
end
datestr_v = D{1}(1:N);

datenum_v = datenum(datestr_v);
precip_cm=precip_in*2.54;

ind_miss = find(precip_TF_miss);
subplot(3,1,3);
plot(datenum_v, precip_cm), hold on

plot(datenum_v(ind_miss), zeros(length(ind_miss), 1), 'xr'), 
%title('Daily precip (in)');
% datetick('x',6);
set(gca,'XLim', xtickv([1, 7]), 'XTick', xtickv, 'XTickLabel', xticklabv, 'FontSize', 18);
ylabel('Precip [cm]');
grid on

%% vertical ref lines when rain
% ind_rain = find(precip_in > 0.01);
% YLimv = get(ax1, 'YLim');
% YLimv2 = get(gca, 'YLim');
% for ii = 1:length(ind_rain)
%     subplot(3,1,[1 2]), hold on
%     plot(ones(1,2)*datenum_v(ind_rain(ii)), YLimv, '--b');
%     subplot(3,1,3), hold on
%     plot(ones(1,2)*datenum_v(ind_rain(ii)), YLimv2, '--b');
% end
% set(ax1, 'YLim', YLimv);
% set(gca, 'YLim', YLimv2);


print('-dtiff', figname);
