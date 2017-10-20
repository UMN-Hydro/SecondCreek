% This script provides an application example for estimating water fluxes 
% based on temperature profile (fluxbot);
% Authors: M.Munz and C. Schmidt, 2016

% Test 3: Experimental Temperature time series - Selke field side (Germany)
% (Details on the temperature data are provided in Munz et al. 2016;
% http://dx.doi.org/10.1016/j.jhydrol.2016.05.012)

% Steps:
% 1. Set required input directories and data information
% 2. Load the datafile (Temperature, Depth)
% 3. Set numerical and thermal parameter
% 4. Run Fluxbot (required time ~30 min)
% 5. Plot Fluxbot results

%------------------------------------------------------------------------%
% !!!setup the Matlab current directory to the fluxbot directory!!!
% use the Evaluate cell and advance buttom to run through this script
%% 1. Set required input directories and data information

clear all
% MANUAL INPUT
 % set working directory, priority folder, if file exist in pwd ´the 
 % existing file is used if not, fileinf.path is used to look up files
fileinf.path_pwd = pwd;     
fileinf.path = ['...'];
fileinf.logger_name = '3_Riverbed_Temperatures';
fileinf.file_extension = '.csv';
fileinf.colum_separation = ';';                     
fileinf.time_format = 2;                     % 1=datenumber; 2=datestrinf   
fileinf.string_format = 'dd.mm.yyyy HH:MM';  % e.g. format: dd.mm.yyyy hh:mm; dd.mm.yyyy hh:mm:ss 
                                             % for others see Standard MATLAB Date Format Definitions 
fileinf.start_date = '22.06.2011 00:00';     % if empty (= [];) evaluation of the whole time series                                                                  
fileinf.end_date = '25.07.2013 23:50';       % if datestr or datenum is given the evaluation will be restricted to all temperatures between start date and end date
                                             % information must be as defind in fileinf.time_format
                                             % T1_D_all: from 22.06.2011
                                             % 14:00 to 25.07.2013 09:40                                
fileinf.oscper = 86400*1;                    % periond of Temperature oscillation [s]; 1 day  = 86400 s

%% 2 Load the datafile 

[data.T_all data.date data.z data.fs] = importdata(fileinf);                                            

% %check Data
% data.T_all;      % matrix with Temperature data °C, DEEPEST IN THE FIRST COLUMN!!!
% data.fs;         % Measuring/Sampling intervall 15 min
% data.z;          % Measuring depth z= 0 0.015 0.065 0.165 0.365 [m]

%% 3  Set numerical and thermal parameter

% MANUAL INPUT
% Divide the temperature time series into  subsection
numpar.wl = round(60/(data.fs/60)*fileinf.oscper/3600);  % window length (one day )
numpar.R = numpar.wl;                             % hop size  [number of samples], when equal to wl then no overlap

% Grid and time stepping
numpar.dt = data.fs;            % time step length [s], ususally equal to the sampling frequency (BESSER: INTERVAL)
numpar.dx = 0.005;               % mesh width 

% Optimization parameters
numpar.slope = 5;               % [-] allowed rate of change for the next qz window when fminsearchbnd is used
numpar.qzi = 3/86400;       % initial guess of qz , flow direction is positive downward
numpar.tol = 10e-6;             % termination tolerance for fminsearch
numpar.maxevaln = 500;          % Maximum number of function for fminsearch 

% Thermal parameters
thermpar.rc = 3761400;          % volumetric heat capacity of of the saturated fluid solid system J/m³/K
thermpar.kfs = 1.58;            % thermal condcuctivity of the saturated sediment W/m/k (saturated fluid solid system?!)
thermpar.rfcf = 4.182e+06;      % volumetric heat capacity of water J/m³/K

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

% or load final results
% load([fileinf.path 'fluxbot_resluts_4.mat'])

%% 5. Plot Fluxbot results
% set plot information
% MANUAL INPUT
plot_info.plot_qz = 'T';                     % 'T', plot specified result; 'F' no result plot                 
plot_info.plot_temperatures = 'T';           % - " -
plot_info.scatter_temperatures = 'T';        % - " -
plot_info.savefigures = 'F';                 % 'T' save figures, 'F' dont save figures 
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