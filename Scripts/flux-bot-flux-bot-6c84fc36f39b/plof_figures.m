function plof_figures(data, plot_info, fileinf, SSE_Temp, NSE_Temp, CORCOEFF_Temp)
% Description: cp. FLUX-BOT user manual

% calculate quality criteria
SSE_Temp = nanmean((data.T_all(:, 2:end-1)-data.T_mod_depth(end:-1:1,:)').^2);
NSE_Temp = ones(1,length(data.T_all(1, 2:end-1))) -...
                (nansum((data.T_all(:, 2:end-1)-data.T_mod_depth(end:-1:1,:)').^2))./...
                (nansum((data.T_all(:, 2:end-1)-meshgrid(nanmean(data.T_all(:, 2:end-1)),1:length(data.T_all(:, 2)))).^2));   
CORCOEFF_Temp = corrcoef([data.T_all(:, 2:end-1) data.T_mod_depth(end:-1:1,:)'], 'rows', 'pairwise');

if plot_info.plot_qz == 'T'
    addpath([pwd '\results'])
    if ~isempty(findobj('name','Calculated vertical fluxes'))
        close('name','Calculated vertical fluxes')
    end
    plot_qz
end

if plot_info.plot_temperatures == 'T'
    addpath([pwd '\results'])
    if ~isempty(findobj('name','Timeseries of Modelled and Simulated Temperatures; Temperature Residuals'))
        close('name','Timeseries of Modelled and Simulated Temperatures; Temperature Residuals')
    end
    plot_temperatures
end

if plot_info.scatter_temperatures == 'T'
    addpath([pwd '\results'])
    if ~isempty(findobj('name','Scatterplot Measured vs. Simulated Temperatures'))
        close('name','Scatterplot Measured vs. Simulated Temperatures')
    end
    scatter_temperatures
end

% write results to text file
for k=1:length(data.qz_opt_all)
    if k == 1
        filename = [pwd '\results\qz_' fileinf.logger_name '_' num2str(data.date(1)) '-' num2str(data.date(end)) fileinf.file_extension];
        fid = fopen(filename, 'w');
        fprintf(fid, ['Depth: '  num2str(data.z)]);
        fprintf(fid, '\n');
        fprintf(fid, ['Mean Square Error: '  num2str(SSE_Temp)]);
        fprintf(fid, '\n');
        fprintf(fid, ['Nash–Sutcliffe Efficiency: '  num2str(NSE_Temp)]);
        fprintf(fid, '\n');
        fprintf(fid, 'date;qz[l/m²/day]');
        fprintf(fid, '\n');
    else
        fprintf(fid, [num2str(data.date(data.date_ind(k))) ';'  num2str(data.qz_opt_all(k))]);          
        fprintf(fid, '\n');
    end
end
fclose(fid);



    function plot_qz
        f1 = figure(1);
        set(f1,'name','Calculated vertical fluxes')
        set(f1, 'units','normalized','outerposition',[0.2 0.2 0.8 0.8])
        if  plot_info.savefigures == 'T'
            set(f1, 'Color', 'none')
        end
        plot(data.date(data.date_ind), data.qz_opt_all*86400000,'+r-'),hold on
        set(gca, 'FontSize', plot_info.fontsize)
        datetick('x', 20, 'keepticks')
        ylabel('qz [Lm^-^2d^-^1]', 'FontSize', plot_info.fontsize)
        xlabel('Time [d]', 'FontSize', plot_info.fontsize)
        xlim([data.date(1) data.date(end)])
        
        if min(data.qz_opt_all) >= 0
            text(...
                data.date(end)+(data.date(end)-data.date(1))/25,...
                (min(data.qz_opt_all)+(max(data.qz_opt_all)-min(data.qz_opt_all))/2)*86400000,...
                'downward flux', 'FontSize', plot_info.fontsize, ...
                'Rotation', 270, 'HorizontalAlignment', 'center')
        elseif max(data.qz_opt_all) <= 0
             text(...
                data.date(end)+(data.date(end)-data.date(1))/25,...
                (min(data.qz_opt_all)-(max(data.qz_opt_all)-min(data.qz_opt_all))/2)*86400000,...
                'upward flux', 'FontSize', plot_info.fontsize, ...
                'Rotation', 270, 'HorizontalAlignment', 'center')
        else
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
        end

        if plot_info.savefigures == 'T'
            export_fig(f1, ['results\' fileinf.logger_name '_' num2str(data.date(1)) '-' num2str(data.date(end)) 'qz.jpg'])   %qz.jpg
        end

    end

    function plot_temperatures
        f2 = figure(2);
        set(f2,'name','Timeseries of Modelled and Simulated Temperatures; Temperature Residuals')
        set(f2, 'units','normalized','outerposition',[0.15 0.15 0.8 0.8])
        if  plot_info.savefigures == 'T'
            set(f2, 'Color', 'none')
        end
        legend_text=[];
        subplot(3,1,[1 2])
        plot1 = plot(data.date,data.T_mod_depth, 'r');
        hold on,
        plot2 = plot(data.date,data.T_all(:, 2:end-1),'k');
        set(gca, 'FontSize', plot_info.fontsize)
        legend([plot1(1) plot2(1)], {'Simulated Temperatures', 'Measured Temperatures'}, 'FontSize', plot_info.fontsize)
        datetick('x', 20, 'keepticks')
        ylabel('Temperature [°C]', 'FontSize', plot_info.fontsize)
        xlabel('Date', 'FontSize', plot_info.fontsize)
        xlim([data.date(1) data.date(end)])
        subplot(3,1,3)
        for i=1:length(data.T_all(1, 2:end-1))
            plot(data.date,(data.T_all(:, i+1) - data.T_mod_depth(length(data.T_mod_depth(:,1))+1-i,:)'), plot_info.col{i})
            hold on
            ylim([-1 1])
            xlim([data.date(1) data.date(end)])
            legend_text = [legend_text {[num2str(data.z(i+1), '%1.3f') ' m']}];
        end
        set(gca, 'FontSize', plot_info.fontsize)
        line([data.date(1), data.date(end)], [0, 0], 'col', 'k')
        legend(fliplr(legend_text), 'FontSize', plot_info.fontsize)
        datetick('x', 20, 'keepticks')
        ylabel('Temperature [°C]', 'FontSize', plot_info.fontsize)
        xlabel('Date', 'FontSize', plot_info.fontsize)
        if plot_info.savefigures == 'T'
            export_fig(f2, ['results\' fileinf.logger_name '_' num2str(data.date(1)) '-' num2str(data.date(end)) 'temperature.jpg'])   %Simulated_Temperatures.jpg
        end
    end

    function scatter_temperatures
        f3 = figure(3);
        set(f3,'name','Scatterplot Measured vs. Simulated Temperatures')
        set(f3, 'units','normalized','outerposition',[0.1 0.1 0.8 0.8])
         if  plot_info.savefigures == 'T'
            set(f3, 'Color', 'none')
        end
         legend_text=[];
        for i=1:length(data.T_all(1, 2:end-1))
             if length(data.T_all(:,1)) > plot_info.number_of_scatterpoints
                    sort_res = sort(abs(data.T_all(:, i+1) - data.T_mod_depth(length(data.T_mod_depth(:,1))+1-i,:)'), 'descend');
                    select_data = find(abs(data.T_all(:, i+1) - data.T_mod_depth(length(data.T_mod_depth(:,1))+1-i,:)')>=sort_res(plot_info.number_of_scatterpoints) | abs(data.T_all(:, i+1) - data.T_mod_depth(length(data.T_mod_depth(:,1))+1-i,:)')<=sort_res(end-0.1*plot_info.number_of_scatterpoints));
             else
                 select_data = (1:length(data.T_all(:,1))');
             end
             
            scatter(data.T_all(select_data, i+1), data.T_mod_depth(length(data.T_mod_depth(:,1))+1-i, select_data)', '.', plot_info.col{i})
            hold on
            legend_text = [legend_text {[num2str(data.z(i+1), '%1.3f') ' m']}];
        end
        set(gca, 'FontSize', plot_info.fontsize)
        line([min(min(data.T_all)) max(max(data.T_all))], [min(min(data.T_all)) max(max(data.T_all))], 'col', 'k')
        legend(fliplr(legend_text), 'FontSize', plot_info.fontsize, 'Location', 'SouthEast')
        xlabel('Measured Temperature [°C]', 'FontSize', plot_info.fontsize)
        ylabel('Simulated Temperature [°C]', 'FontSize', plot_info.fontsize)
    
        x = double(min(min(data.T_all)));
        y = double(max(max(data.T_all)));
        diff = y-x;
        for j=1:length(SSE_Temp)
            if j==1
                text(x+diff*0.02,y-diff*0.05, 'Depth [m]: ',  'FontSize', plot_info.fontsize)
                text(x+diff*0.02,y-diff*0.1, 'Mean Square Error: ',  'FontSize', plot_info.fontsize)
                text(x+diff*0.02,y-diff*0.15, 'Nash–Sutcliffe Efficiency: ',  'FontSize', plot_info.fontsize)
                text(x+diff*0.02,y-diff*0.2, 'Corellation Coefficient: ',  'FontSize', plot_info.fontsize)
            end
            text(x+diff*0.2+diff*0.06*j,y-diff*0.05, num2str(data.z(j+1), '%1.2f'),  'FontSize', plot_info.fontsize)
            text(x+diff*0.2+diff*0.06*j,y-diff*0.1,  num2str(SSE_Temp(end+1-j), '%1.2f'),  'FontSize', plot_info.fontsize)
            text(x+diff*0.2+diff*0.06*j,y-diff*0.15, num2str(NSE_Temp(end+1-j), '%1.2f'),  'FontSize', plot_info.fontsize)
            text(x+diff*0.2+diff*0.06*j,y-diff*0.2, num2str(CORCOEFF_Temp((length(CORCOEFF_Temp)/2)+j,j), '%1.2f'),  'FontSize', plot_info.fontsize)
        end
        xlim([x y]) 
        ylim([x y])
        if plot_info.savefigures == 'T'
           export_fig(f3, ['results\' fileinf.logger_name '_' num2str(data.date(1)) '-' num2str(data.date(end)) 'scatter.jpg'])   %Scatter.jpg
        end
    end
end %function