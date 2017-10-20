function [T_all date z_sort_asc fs] = importdata(fileinf)
% Description: cp. FLUX-BOT user manual

% CHECK IF fileinf.time_format is 1||2; if fileinf.start_date and
% fileinf.end_date is >= or <= date(1) or date(end) (time is part of the
% time vector) is and if fileinf.start-fileinf.end_date >= fs 
% check if temperture measurements >=3 

if exist([fileinf.path_pwd '\' fileinf.logger_name fileinf.file_extension])
    filename = [fileinf.path_pwd '\' fileinf.logger_name fileinf.file_extension];
    
else  
    if exist([fileinf.path fileinf.logger_name fileinf.file_extension])
        filename = [fileinf.path fileinf.logger_name fileinf.file_extension];
    end
end

if exist('filename') == 0
    error('File does not exist; neither in workdir nor in fileinf.path')
else
    fid = fopen(filename, 'r');
end

if fid == -1
    error('Invalid file')
else
    fprintf('Read temperature date file:')
    filename
    if fileinf.time_format == 1
        % NOT CHECKED YET
         header = fgetl(fid);
         T = textscan(fid, '%f32%f32%f32%f32%f32%f32%f32%f32%f32%f32', 'delimiter', fileinf.colum_separation, 'HeaderLines', 1);
    elseif fileinf.time_format == 2
        %read all data
        header = fgetl(fid);
        T = textscan(fid, ['%' num2str(length(fileinf.string_format)) '19s%f32%f32%f32%f32%f32%f32%f32%f32'], 'delimiter', fileinf.colum_separation, 'HeaderLines', 0);
        T{1} = datenum(T{1}, fileinf.string_format);
    end
end
fclose(fid)

if isempty(T{1})
    error('No data read; proove all fileinf settings; e.g. path and file names and time settings/format')
end

% extract header information
% Measuring depth z= 0 0.015 0.065 0.165 0.365 [m]
pos = find(header==',');
z=[];
for i=1:length(pos)
    if i==length(pos)
        z(i)=str2num(header((pos(i)+1):end));
    else
        z(i)=str2num(header((pos(i)+1):(pos(i+1)-1)));
    end
end

% extract Time information
% Measuring intervall 15 min (Temperature and samplng intervall)
% check if data have equidistant time steps

if fileinf.time_format == 1
    pos_time = find((T{1}(2:end)-T{1}(1:end-1)) - (T{1}(2)-T{1}(1)) >= (T{1}(2)-T{1}(1)));
    if length(pos_time)>=1
        error(['Non equel time step at: ' datestr(T{1}(pos_time(1)), fileinf.string_format)])
    else
        fs = (T{1}(2)-T{1}(1)) * 86400;     
    end
elseif fileinf.time_format == 2
    pos_time = find((T{1}(2:end)-T{1}(1:end-1)) - (T{1}(2)-T{1}(1)) >= (T{1}(2)-T{1}(1)));
    if length(pos_time)>=1
        error(['Non equel time step at: ' datestr(T{1}(pos_time(1)), fileinf.string_format)])
    else
        fs = (T{1}(2)-T{1}(1)) * 86400;     
    end
end

% sort matrix with Temperature data °C, DEEPEST IN THE FIRST COLUMN!!!
[z_sort_desc IX]= sort(z, 'descend');   % 'descend'
for j=1:length(z)
    T_all(:,j) = T{IX(j)+1};
end
z_sort_asc = sort(z);  

% select all temperatures measured between start_date and end_date
if isempty(fileinf.start_date) 
     T_all = T_all;
     date = T{1};
else
    if fileinf.time_format == 1
        if fileinf.end_date - fileinf.start_date <= fileinf.oscper/86400
            error('Time series shorter than minimum time interval; proove date start and date end; no data read')
        end          
    elseif fileinf.time_format == 2
        fileinf.start_date = datenum(fileinf.start_date, fileinf.string_format);
        fileinf.end_date = datenum(fileinf.end_date, fileinf.string_format);
        if fileinf.end_date - fileinf.start_date <= fileinf.oscper/86400
            error('Time series shorter than minimum time interval; proove date start and date end; no data read')
        end          
    end
    
    T_all = T_all(find(T{1}>=fileinf.start_date & T{1}<=fileinf.end_date),:);  
    date =  T{1}(find(T{1}>=fileinf.start_date & T{1}<=fileinf.end_date),:);  
end


% Check for NaN; -> NOT ALLOWED FOR FMINSEARCH
% try to remove
if sum(sum(isnan(T_all)))>1
    % REMOVE COLUMNS
    if sum(sum(isnan(T_all))>=1)==1
        warning(['NaNs in Temperature file: ' num2str(sum(isnan(T_all)))])
        warning(['column ' num2str(find(sum(isnan(T_all)))) ' removed'])
        z_sort_asc(find(sum(isnan(T_all)))) = [];
        T_all(:,find(sum(isnan(T_all)))) = [];
    else
        % REMOVE ROWS???
        if sum(sum(isnan(T_all)')>=1)>=1
            warning('NaNs in Temperature file:')
            warning(['rows with NaN removed'])
            date(find(sum(isnan(T_all'))),:)=[];
            T_all(find(sum(isnan(T_all'))),:)=[];
        end
    end
end
        

end %function
