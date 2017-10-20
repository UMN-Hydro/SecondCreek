% This script provides an application example for estimating water fluxes 
% based on temperature profile (fluxbot);
% Authors: M.Munz and C. Schmidt, 2016

% Test 2: Experimental temperature time series measured under controlled
% hydrological conditions in a sand box experiment (Details on the experiment
% are provided in Munz et al. 2011; http://dx.doi.org/10.5194/hess-15-3495-2011)

% Steps:
% 1. Load Temperature time series and set input data
% 2. Set numerical and thermal parameter
% 3. Run Fluxbot (required time ~1 min)
% 4. Plot Fluxbot results
% 5. Plot results of Monte Carlo Simulation (or perform MCS)

%------------------------------------------------------------------------%
% !!!setup the Matlab current directory to the fluxbot directory!!!
% use the Evaluate cell and advance buttom to run through this script

%% 1. Load Temperature time series and set input data

clear all
% Set data file information
fileinf.path_pwd = pwd;                      % set working directory, priority folder, if file exist in pwd ´the existing file is used if not, fileinf.path is used to look up files    
fileinf.path = ['...'];
fileinf.logger_name = '2_Sandbox_Experiment_Temperatures';
fileinf.file_extension = '.txt';
fileinf.oscper = 86400*1;                    % periond of Temperature oscillation [s]; 1 day  = 86400 s   

% Load temperature and flux data from Munz et al. 2011
load ([fileinf.path_pwd '\2_Sandbox_Experiment_Temperatures.mat'])
data.T_all = fliplr(T_munz);                % Matrix with Temperature data °C, deepest in the first column
data.z = [0 0.015 0.065 0.165 0.365] ;      % Measuring depth [m]                      
data.fs = 15*60;                            % Sampling interval in [s]
data.date = ((1:length(data.T_all)) * data.fs)';

%% 2  Set numerical and thermal parameter

% MANUAL INPUT
% Divide the temperature time series into  subsection
numpar.wl = round(60/(data.fs/60)*fileinf.oscper/3600);     %window length [number of samples]
numpar.R=numpar.wl;                                         %=hop size  [number of samples], when equal to wl then no overlap

% Grid and time stepping
numpar.dt = data.fs;            % time step length [s], ususally equal to the sampling frequency (BESSER: INTERVAL)
numpar.dx = 0.005;              % mesh width 

% Optimization parameters
numpar.slope = 10;              % [-] allowed rate of change for the next qz window when fminsearchbnd is used
numpar.qzi = 1.5/86400;         % initial guess of qz , flow direction is positive downward
numpar.tol = 10e-6;             % termination tolerance for fminsearch
numpar.maxevaln = 500;          % Maximum number of function for fminsearch 

% Thermal parameters
thermpar.rc = 3.20e+06;         % volumetric heat capacity of of the saturated fluid solid system J/m³/K % 4e+06
thermpar.kfs = 2.58;            % thermal condcuctivity of the saturated sediment W/m/k (saturated fluid solid system?!) % 4.75
thermpar.rfcf = 4.182e+06;      % volumetric heat capacity of water J/m³/K

%% 3. Run Fluxbot
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

%% 4. Plot Fluxbot results

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

%% 5. Plot results of Monte Carlo Simulation (or perform MCS)

% MANUAL INPUT
MC_info.dist = 'normal'
MC_info.num_sens_run = 1000;
MC_info.rc_error = 5e+05; 
MC_info.kfs_error = 0.3;
MC_info.T_error = 0.05;
MC_info.z_error = 0.01;
% set additional plot information
plot_info.plot_parameter_dist = 'T';         % 'T', plot specified result; 'F' no result plot                 
plot_info.plot_uncertainty_bounds = 'T';     % 'T', plot specified result; 'F' no result plot                 
% set parellel computing information
parallel_info.num_of_workers = 48;
% set expected operation time of parallel pool (parpool) on the 'local' profile
parallel_info.est_run_time = MC_info.num_sens_run * data.run_time * 5      % in s


% % insted of running the uncertainty simulation load datafile with already
% % completed MC simulation (for details check MC_info)
    load([fileinf.path_pwd '\2_Sandbox_Experiment_Sensitivity.mat'])
    data.q_sens = qz_sens;
    f5 = figure(5);
    set(f5,'name','Mean calculated vertical fluxes and uncertainty bounds')
    set(f5, 'units','normalized','outerposition',[0.0 0.0 0.8 0.8])
        plot(round(data.date(data.date_ind)/86400), (mean(data.q_sens')*86400000),'+r-'),hold on
        plot(round(data.date(data.date_ind)/86400), (mean(data.q_sens')*86400000 + std(data.q_sens')*86400000),':r')
        plot(round(data.date(data.date_ind)/86400), (mean(data.q_sens')*86400000 - std(data.q_sens')*86400000),':r')
        set(gca, 'FontSize', plot_info.fontsize)
        ylabel('qz [Lm^-^2d^-^1]', 'FontSize', plot_info.fontsize)
        xlabel('Time [d]', 'FontSize', plot_info.fontsize)
        xlim([round(data.date(1)/86400) round(data.date(end)/86400)])
        set(gca, 'FontSize', plot_info.fontsize-2)
        legend(['mean q of ' num2str(MC_info.num_sens_run) ' sensitivity runs (q_{mean ' num2str(MC_info.num_sens_run) '})'],...
            ['q_{mean ' num2str(MC_info.num_sens_run) '} +- Standartdeviation of q_{mean ' num2str(MC_info.num_sens_run) '}'])
        clear('f5')

%% run MCS  
% [qz_sens, data, thermpar] = uncertainty_analyses(data, numpar, thermpar, MC_info, plot_info, parallel_info)
% data.q_sens = qz_sens;