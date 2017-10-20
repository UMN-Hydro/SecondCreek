function [q_sens, data, thermpar]=uncertainty_analyses(data, numpar, thermpar, MC_info, plot_info, parallel_info)
% Description: cp. FLUX-BOT user manual
    
    disp(['expected run time of all Monte Carlo simulations is ' num2str(parallel_info.est_run_time/60/parallel_info.num_of_workers) , ' minutes'])
    % UNCERTAINTY BOUNDS
    if MC_info.dist == 'normal'
        disp('normal distribution with given mean and standarddeviation used to generate input parameter space')
        % create parameterdistribution % normal distribution
        rc_range = random('Norm',thermpar.rc,MC_info.rc_error,MC_info.num_sens_run,1);
        % rescale std to avoid negative numbers
        if  sum(rc_range<=0)>0
            warning('Negative errors occured in generated distribution  of Volumetric heat capacity of of the saturated fluid solid system; Standard deviation automatically reduced')
            del1 = find(rc_range > (mean(rc_range) + (mean(rc_range) - 500000)) | rc_range < 500000);
            %thermpar.rc_sens = (rc_range - (min(rc_range))) ./ ((max(rc_range) - (min(rc_range)))/(max(rc_range)));
            %MC_info.rc_error = std(thermpar.rc_sens);
        else
            del1 = [];
            % thermpar.rc_sens = rc_range;
        end

        kfs_range = random('Norm',thermpar.kfs,MC_info.kfs_error,MC_info.num_sens_run,1);
        % rescale std to avoid negative numbers
        if  sum(kfs_range<=0)>0
            warning('Negative errors occured in generated distribution  of Thermal condcuctivity of the saturated sediment; Standard deviation automatically reduced')
            del2 = find(kfs_range > (mean(kfs_range) + (mean(kfs_range) - 0.25)) | kfs_range < 0.25);
            % thermpar.kfs_sens = (kfs_range - (min(kfs_range))) ./ ((max(kfs_range) - (min(kfs_range)))/(max(kfs_range)));
            % MC_info.kfs_error = std(thermpar.kfs_sens);
        else
            del2 = [];
            %thermpar.kfs_sens = kfs_range;
        end

        % cut unrealistic edges of parameter distribution
        %if ~isempty(del1) | ~isempty(del2)
            rc_range([del1', del2']') = [];
            thermpar.rc_sens = rc_range;
            kfs_range([del1', del2']') = [];
            thermpar.kfs_sens = kfs_range;
        %end
    
    else
        disp('equal distribution over complete paremeter range used to generate input parameter space')
        % equal distribution
        thermpar.rc_sens  = (0.5+(7.5-0.5)*rand(MC_info.num_sens_run,1));
        thermpar.kfs_sens = (500000+(6000000-500000)*rand(MC_info.num_sens_run,1));
    end
    
    data.T_sens = random('Norm',0,MC_info.T_error,length(rc_range),length(data.z));
    data.z_sens= fix(random('Norm',0,MC_info.z_error*100,length(rc_range),length(data.T_all(1,:))))*numpar.dx;
  
    % deviation in z not higher than difference between two adjacent loggers,
    % in that case the error is assumed to be minimal (0)
    z_sens(:,1)=0; 
    for is = 1:(length(data.z)-1)
       data.z_sens((abs(data.z_sens(:,is) - data.z_sens(:,is+1))>=(data.z(is+1)-data.z(is))+(data.z(is+1)-data.z(is))/10),is+1)=0;
    end
    
    
    % plot parameter distribution
    if plot_info.plot_parameter_dist == 'T'
        addpath([pwd '\results'])
        if ~isempty(findobj('name','Parameter Distribution'))
            close('name','Parameter Distribution')
        end
    plot_parameter_dist
    end
    
    % initialise result matrix for uncertainty runs
    T_all_sens = NaN(length(data.T_all(1,:)), length(rc_range)); %MC_info.num_sens_run);
    q_sens = NaN(length(data.qz_opt_all), length(rc_range)); %MC_info.num_sens_run);
    
    % run fluxbot wiht Monte Carlo Parameter set
    % take care of overall simulation time, can be very long if
    % MC_info.num_sens_run is high. Try to use multiple cores.
    % check if paralel functions are available (Parallelisation Toolbox is installed)
    cluster = which('parcluster');
    if  parallel_info.num_of_workers == 0 || isempty(cluster)
        % run slope
        if isempty(cluster)
            warning(['Missing Parallelisation Toolbox, no parallelisation possible, run on single node, expected run time ', num2str(parallel_info.est_run_time/60), ' minutes'])
        end
        
        for i=1:length(rc_range) %MC_info.num_sens_run
            disp(['fluxbot Monte Carlo run ', num2str(i), ' in progress'])
            
            data_sens = data;
            data_sens.T_all = data.T_all + repmat(data.T_sens(i,:),length(data.T_all(:,1)),1);
            data_sens.z = sort(data.z + data.z_sens(i,:))
            thermpar_sens = thermpar;
            thermpar_sens.kfs = thermpar.kfs_sens(i)
            thermpar_sens.rc = thermpar.rc_sens(i)

            [q_sens(:,i)] =  fluxbot5(data_sens, numpar, thermpar_sens);
        end
    else
        % Monte carlo simulation, use parallel computing if possible
        % use parallel cumputation (parfor (parallel processing toolbox))
        % check num of workers and local pool size, define number of workers 
        % and start parallel pool
        % number of nodes available
        ci = parcluster;
        if isempty(cluster)
           poolsize = 0;
           warning('no cluster found for parallel computing of parfor')
        elseif ci.NumWorkers < parallel_info.num_of_workers 
            parallel_info.num_of_workers = ci.NumWorkers
            warning(['parallel_info.num_of_workers higher than actual poolsize, parallel_info.num_of_workers  set to ' num2str(poolsize)])  
        end
        % creating a special job on a pool of workers
        parpool(parallel_info.num_of_workers, 'IdleTimeout', int32(parallel_info.est_run_time)) 
        % run slope in parallel
        
        parfor i=1:length(rc_range) %MC_info.num_sens_run
            if i>=1
                disp(['fluxbot Monte Carlo run ', num2str(i), ' in progress'])

                data_sens = data;
                data_sens.T_all = data.T_all + repmat(data.T_sens(i,:),length(data.T_all(:,1)),1);
                data_sens.z = sort(data.z + data.z_sens(i,:))
                thermpar_sens = thermpar;
                thermpar_sens.kfs = thermpar.kfs_sens(i)
                thermpar_sens.rc = thermpar.rc_sens(i)

                [q_sens(:,i)] =  fluxbot5(data_sens, numpar, thermpar_sens); 
            else
                warning(['Attempt to reference field of non-structure array'])
            end
        end
        
        %end
        % terminate the existing parallel session
        delete(gcp)
    end
    
    if plot_info.plot_uncertainty_bounds == 'T'
        addpath([pwd '\results'])
        if ~isempty(findobj('name','Calculated vertical flow velocity and uncertainty bounds'))
            close('name','Calculated vertical flow velocity and uncertainty bounds')
        end
    plot_uncertainty_bounds
    end

    % plot functions
    function plot_parameter_dist
        % plot final parameter distribution with mean, and adapted std
        bins = 20;
        f4= figure(4);
        set(f4,'name','Paramaterdistribution of Sensitivity Runs')
        set(f4, 'units','normalized','outerposition',[0.05 0.05 0.8 0.8])
        if  plot_info.savefigures == 'T'
            set(f4, 'Color', 'none')
        end
        set(gca, 'FontSize', plot_info.fontsize)

        subplot(2,2,1)
        hist(thermpar.rc_sens, bins);
        set(findobj(gca,'Type','patch'),'FaceColor','k','EdgeColor','w')
        xlabel('Volumetric heat capacity of the saturated sediment [J/m³/K]', 'FontSize', plot_info.fontsize)
        ylabel('Absolute frequency', 'FontSize', plot_info.fontsize)
        xlim([0 8e+06])
        text(5e+06 ,max(hist(thermpar.rc_sens, bins)) - 1/10*max(hist(thermpar.rc_sens, bins)), ['mean    = ' num2str((thermpar.rc), '%1.1e')],  'FontSize', plot_info.fontsize)
        text(5e+06 ,max(hist(thermpar.rc_sens, bins)) - 2/10*max(hist(thermpar.rc_sens, bins)), ['std.dev = ' num2str((MC_info.rc_error), '%1.1e')],  'FontSize', plot_info.fontsize)

        subplot(2,2,2)
        hist(thermpar.kfs_sens, bins)
        set(findobj(gca,'Type','patch'),'FaceColor','k','EdgeColor','w')
        xlabel('Thermal condcuctivity of the saturated sediment [W/m/k]', 'FontSize', plot_info.fontsize)
        ylabel('Absolute frequency', 'FontSize', plot_info.fontsize)
        xlim([0 8])
        text(6 ,max(hist(thermpar.kfs_sens, bins)) - 1/10*max(hist(thermpar.kfs_sens, bins)), ['mean    = ' num2str((thermpar.kfs), '%1.1f')],  'FontSize', plot_info.fontsize)
        text(6 ,max(hist(thermpar.kfs_sens, bins)) - 2/10*max(hist(thermpar.kfs_sens, bins)), ['std.dev = ' num2str((MC_info.kfs_error), '%1.1f')],  'FontSize', plot_info.fontsize)

        subplot(2,2,3)
        legend_text=[];
        for is =1:length(data.z)
            legend_text = [legend_text {[num2str(data.z(is), '%1.3f') ' m']}];
        end
        hist(data.T_sens)
        if MC_info.T_error ~= 0
            xlim([-MC_info.T_error*5 MC_info.T_error*5])
        end
        xlabel('Temperature deviation [K]', 'FontSize', plot_info.fontsize)
        ylabel('Absolute frequency', 'FontSize', plot_info.fontsize)
        h = legend(legend_text, 'FontSize', plot_info.fontsize-2, 'Location', 'West');
        %set(get(h,'title'),'string','Sensor depth', 'FontSize', plot_info.fontsize);
        if MC_info.z_error ~= 0 
            text(MC_info.T_error*2 ,max(max(hist(data.T_sens)) - 2/10*max(hist(data.T_sens))), ['std.dev = ' num2str((MC_info.T_error), '%1.3f')],  'FontSize', plot_info.fontsize)
        end
           
        subplot(2,2,4)
        hist(data.z_sens)
        if MC_info.z_error ~= 0
            xlim([-MC_info.z_error*3-0.01 MC_info.z_error*3])
        end
        xlabel('Location deviation [m]', 'FontSize', plot_info.fontsize)
        ylabel('Absolute frequency', 'FontSize', plot_info.fontsize)
        h = legend(legend_text, 'FontSize', plot_info.fontsize-2, 'Location', 'West');
        %set(get(h,'title'),'string','Sensor depth', 'FontSize', plot_info.fontsize);
        if MC_info.z_error ~= 0
            text(MC_info.z_error ,max(max(hist(data.z_sens)) - 2/10*max(hist(data.z_sens))), ['std.dev = ' num2str((MC_info.z_error), '%1.3f')],  'FontSize', plot_info.fontsize)
        end
        
        if plot_info.savefigures == 'T'
            export_fig(f4, ['results\' fileinf.logger_name '_' num2str(data.date(1)) '-' num2str(data.date(end)) 'parameter_dist.jpg'])   %qz.jpg
        end
    end

    function plot_uncertainty_bounds
    f5 = figure(5);
        set(f5,'name','Mean calculated vertical fluxes and uncertainty bounds')
        set(f5, 'units','normalized','outerposition',[0.0 0.0 0.8 0.8])
        if  plot_info.savefigures == 'T'
            set(5, 'Color', 'none')
        end
         plot(data.date(data.date_ind), (mean(q_sens')*86400000),'+b-'),hold on
         plot(data.date(data.date_ind), (mean(q_sens')*86400000 + 2*std(q_sens')*86400000),':b')
%         %plot(data.date(data.date_ind), (mean(q_sens(:,1:100)')),'xg-')
%         %plot(data.date(data.date_ind), (mean(q_sens(:,1:100)') + std(q_sens(:,1:100)')),':g')
         plot(data.date(data.date_ind), (mean(q_sens')*86400000 - 2*std(q_sens')*86400000),':b')
%         %plot(data.date(data.date_ind), (mean(q_sens(:,1:100)') - std(q_sens(:,1:100)')),':g')
        set(gca, 'FontSize', plot_info.fontsize)
        datetick('x', 20, 'keepticks')
        ylabel('qz [Lm^-^2d^-^1]', 'FontSize', plot_info.fontsize)
        xlabel('Time [d]', 'FontSize', plot_info.fontsize)
        xlim([data.date(1) data.date(end)])
        set(gca, 'FontSize', plot_info.fontsize-2)
        legend(['mean q of ' num2str(MC_info.num_sens_run) ' sensitivity runs (q_{mean ' num2str(MC_info.num_sens_run) '})'],...
            ['q_{mean ' num2str(MC_info.num_sens_run) '} +- Standartdeviation of q_{mean ' num2str(MC_info.num_sens_run) '}'])
        
        legend(['mean q of ' num2str(MC_info.num_sens_run) ' sensitivity runs (q_{mean ' num2str(MC_info.num_sens_run) '})'],...
            ['q_{mean ' num2str(MC_info.num_sens_run) '} +- Standartdeviation of q_{mean ' num2str(MC_info.num_sens_run) '}'])
 
        
%         if min(data.qz_opt_all) >= 0
%             text(...
%                 data.date(end)+(data.date(end)-data.date(1))/25,...
%                 (min(data.qz_opt_all)+(max(data.qz_opt_all)-min(data.qz_opt_all))/2)*86400000,...
%                 'downward flux', 'FontSize', plot_info.fontsize, ...
%                 'Rotation', 270, 'HorizontalAlignment', 'center')
%         elseif max(data.qz_opt_all) <= 0
%              text(...
%                 data.date(end)+(data.date(end)-data.date(1))/25,...
%                 (min(data.qz_opt_all)-(max(data.qz_opt_all)-min(data.qz_opt_all))/2)*86400000,...
%                 'upward flux', 'FontSize', plot_info.fontsize, ...
%                 'Rotation', 270, 'HorizontalAlignment', 'center')
%         else
%              text(...
%                 data.date(end)+(data.date(end)-data.date(1))/25,...
%                 (0+max(data.qz_opt_all)/2)*86400000,...
%                 'downward flux', 'FontSize', plot_info.fontsize, ...
%                 'Rotation', 270, 'HorizontalAlignment', 'right')
%             text(...
%                 data.date(end)+(data.date(end)-data.date(1))/25,0,...
%                 '|', 'FontSize', plot_info.fontsize, ...
%                 'Rotation', 90, 'HorizontalAlignment', 'right')
%              text(...
%                 data.date(end)+(data.date(end)-data.date(1))/25,...
%                 (0+min(data.qz_opt_all)/2)*86400000,...
%                 'upward flux', 'FontSize', plot_info.fontsize, ...
%                 'Rotation', 270, 'HorizontalAlignment', 'left')
%              line([data.date(1) data.date(end)], [0 0], 'color', 'k')
%         end

        if plot_info.savefigures == 'T'
            export_fig(f5, ['results\' fileinf.logger_name '_' num2str(data.date(1)) '-' num2str(data.date(end)) 'qz_sens.jpg'])   %qz.jpg
        end
    end
end