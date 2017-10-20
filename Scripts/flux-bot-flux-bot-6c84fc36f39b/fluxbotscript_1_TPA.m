% This script provides an application example for estimating water fluxes 
% based on temperature profile (FLUX-BOT);
% Authors: M.Munz and C. Schmidt, 2016

% Test 1: Syntetic time series (compare fluxbot estimates of vertical flow 
% velocity with syntetic flow velocities set in the HydroGeoSphere foreward 
% model used to simulate Temperature time series)

% Steps:
% 1. Set required input directories and data information
% 2. Load the datafile (Temperature, Depth)
% 3. Set numerical and thermal parameter
% 4. Run Fluxbot (required time ~2 min)
% 5. Plot Fluxbot r+esults
% 6. Plot results of Monte Carlo Simulation (or perform MCS)

%------------------------------------------------------------------------%
% !!!setup the Matlab current directory to the fluxbot directory!!!
% use the Evaluate cell and advance buttom to run through this script

%% 1. Set required input directories and data information
clear all
% MANUAL INPUT
fileinf.path_pwd = pwd;                      % set working directory, priority folder, if file exist in pwd ´the existing file is used if not, fileinf.path is used to look up files    
fileinf.path = ['C:\SecondCreekGit\TempProbeAnalysis\FormattedTempData\'];                      % temperature data directory
fileinf.logger_name = 'TPA_CalibData_FLUXBOTtrunnc';   % temperature file name
fileinf.file_extension = '.csv';
fileinf.colum_separation = ',';                     
fileinf.time_format = 2;                     % 1=datenumber; 2=datestrinf   
fileinf.string_format = 'mm/dd/yyyy HH:MM';  % e.g. format: dd.mm.yyyy hh:mm; dd.mm.yyyy hh:mm:ss 
                                             % for others see Standard MATLAB Date Format Definitions
fileinf.start_date = ['5/31/2016 9:00'];                     % if empty (= [];) evaluation of the whole time series                                                                  
fileinf.end_date = ['7/31/2016 8:40'];                       % if datestr or datenum is given the evaluation will be restricted to all temperatures between start date and end date
                                             % information must be as defind in fileinf.time_format
                                             % time for TEST3: 02.06.2010 00:00 to 05.09.2010 23:45                                                                                        
fileinf.oscper = 86400*1;                    % periond of Temperature oscillation [s]; 1 day  = 86400 s

%% 2 Load the datafile 

[data.T_all data.date data.z data.fs] = importdata(fileinf);       

% %check Data
% data.T_all;      % matrix with Temperature data °C, DEEPEST IN THE FIRST COLUMN!!!
% data.z;          % Measuring depth z= 0 0.015 0.065 0.165 0.365 [m]
% data.fs;         % Measuring/Sampling intervall 15 min

%% 3  Set numerical and thermal parameter

% MANUAL INPUT
% Divide the temperature time series into  subsection
numpar.wl = round(60/(data.fs/60)*fileinf.oscper/3600);  % window length (one day )
numpar.R = numpar.wl;                                    % hop size  [number of samples], when equal to wl then no overlap

% Grid and time stepping
numpar.dt = data.fs;             % time step length [s], ususally equal to the sampling frequency (BESSER: INTERVAL)
numpar.dx = 0.005;               % mesh width 

% Optimization parameters
numpar.slope = 10;               % [-] allowed rate of change for the next qz window when fminsearchbnd is used
numpar.qzi = -2/86400;           % initial guess of qz , flow direction is positive downward
numpar.tol = 10e-6;              % termination tolerance for fminsearch
numpar.maxevaln = 1000;          % Maximum number of function for fminsearch 

% Thermal parameters
thermpar.rc = 3.17e+06;          % volumetric heat capacity of of the saturated fluid solid system J/m³/K
thermpar.kfs = 0.7 %1.58;      % thermal condcuctivity of the saturated sediment W/m/k (saturated fluid solid system?!)
thermpar.rfcf = 4.12e+06;      % volumetric heat capacity of water J/m³/K

%% 4. Run Fluxbot
%----------------------------------------------------------------------%
% for details cp FLUX-BOT user manual; 
% Munz and Schmidt: Estimation of vertical water fluxes from temperature 
% time series by the inverse numerical computer program FLUX-BOT, 2016
%----------------------------------------------------------------------%
%       ...IIIII...
%       .  *   *  .
%      [.    x    .]
%       .   ~~~   .
%       ...........

tic
[qz_opt_all, data] = fluxbot5(data, numpar, thermpar);
data.run_time = toc;

%% 5. Plot Fluxbot results
% set plot information
% MANUAL INPUT
plot_info.plot_qz = 'T';                     % 'T', plot specified result; 'F' no result plot                 
plot_info.plot_temperatures = 'T';           % - " -
plot_info.scatter_temperatures = 'T';        % - " -
plot_info.savefigures = 'T';                 % 'T' save figures, 'F' dont save figures 
plot_info.number_of_scatterpoints = 5000;     % only scatter n pairs with highest and n pairs with lowest Residuals
                                             % to reduce time to generate and save plot for long time series 
plot_info.col =  {'m' 'g' 'b' 'r' 'k' 'y' 'k', 'g', 'k'};  % used colors {'k' 'k' 'k' 'k' 'k' 'k'}
plot_info.fontsize =  12;                    % set Fontsize

% create result directory
if ~exist('results','dir')
    mkdir('results')
end

% plot and save figures (if selected) and write results to text file
plof_figures(data, plot_info, fileinf)

%% 6. Plot results of Monte Carlo Simulation (or perform MCS)
% MANUAL INPUT
MC_info.dist = 'normal'
MC_info.num_sens_run = 1000;
MC_info.rc_error = 5e+05; 
MC_info.kfs_error = 0.3;
MC_info.T_error = 0.05;
MC_info.z_error = 0.01; 
% set additional plot information
plot_info.plot_parameter_dist = 'T';                     % 'T', plot specified result; 'F' no result plot                 
plot_info.plot_uncertainty_bounds = 'T';                 % 'T', plot specified result; 'F' no result plot                 
% set parellel computing information
parallel_info.num_of_workers = 24;
% set expected operation time of parallel pool (parpool) on the 'local' profile
parallel_info.est_run_time = MC_info.num_sens_run * data.run_time * 10      % in s


% % insted of running the uncertainty simulation load datafile with already
% % completed MC simulation (for details check MC_info)
    load('1_Generic_Test_Case_Sensitivity.mat')

    f5 = figure(5);
    set(f5,'name','Mean calculated vertical fluxes and uncertainty bounds')
    set(f5, 'units','normalized','outerposition',[0.0 0.0 0.8 0.8])
        plot(data.date(data.date_ind), (mean(data.q_sens')*86400000),'+b-'),hold on
        plot(data.date(data.date_ind), (mean(data.q_sens')*86400000 + std(data.q_sens')*86400000),':b')
        plot(data.date(data.date_ind), (mean(data.q_sens')*86400000 - std(data.q_sens')*86400000),':b')
        set(gca, 'FontSize', plot_info.fontsize)
        datetick('x', 20, 'keepticks')
        ylabel('qz [Lm^-^2d^-^1]', 'FontSize', plot_info.fontsize)
        xlabel('Time [d]', 'FontSize', plot_info.fontsize)
        xlim([data.date(1) data.date(end)])
        set(gca, 'FontSize', plot_info.fontsize-2)
        legend(['mean q of ' num2str(MC_info.num_sens_run) ' sensitivity runs (q_{mean ' num2str(MC_info.num_sens_run) '})'],...
            ['q_{mean ' num2str(MC_info.num_sens_run) '} +- Standartdeviation of q_{mean ' num2str(MC_info.num_sens_run) '}'])
        clear('f5')

%% run MCS  
[qz_sens, data, thermpar] = uncertainty_analyses(data, numpar, thermpar, MC_info, plot_info, parallel_info)
data.q_sens = qz_sens;
