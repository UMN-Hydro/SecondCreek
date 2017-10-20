function  [qz_opt_all, data]=fluxbot5(data, numpar, thermpar);
% fluxbot5, Version 1.0.0, Jan. 05, 2016
% M. Munz and C. Schmidt
% Contact: munz@uni-potsdam.de and christian.schmidt@ufz.de

% for details of the method see: Matthias Munz and Christian Schmidt, 2016,
% Estimation of vertical water fluxes from temperature time series by the inverse 
% numerical computer program FLUX-BOT

% for details of the in- and outputs see the FLUX-BOT user manual
% (included in the FLUXBOT folder)

    Nx=size(data.T_all,1);
    overlap=numpar.wl-numpar.R;
    k = fix((Nx-overlap)/(numpar.wl-overlap)); % calculate the number of overlapping patches
    indexs=[];                                 % initialize the index matrix

    for m = 1:k;
        indexs(:,m) = (m-1)*numpar.R+1:min((m-1)*numpar.R+numpar.wl,Nx);
    end

    date_ind=ceil(median(indexs));             % provides indizes for the date to extract from the numerical date vector
    data.date_ind = date_ind;

    % inverse optimization of qz (qz_opt_all) 
    [qz_opt_all, data, N, L]= WTF_calc(data, numpar, k, indexs); % here most of the work is done
    data.qz_opt_all = qz_opt_all;

    % initialisation
    qz_mod=zeros(indexs(end,end),1);            
    Tx=numel(indexs);                 
    initial_temperature_profile = 0;     
    % initialisation of result vectors
    T_all_mod = NaN(Nx, N+2);
    T_mod_depth = NaN(length(data.date_ind2),Nx);
    
    % forward calcutation of Temperature time series based on optimized
    % vertical water fluxes (create result matrix)
    for jm=1:k
        index=indexs(:,jm);
        qz_mod(index)=qz_opt_all(jm);
        [T_all_mod(index,:),T_mod_depth(:,index)]=...
            WTF_forward(data,qz_mod(index),jm,index, initial_temperature_profile);
        initial_temperature_profile = T_all_mod((index(end)-overlap),:);
    end
    
    data.T_all_mod = T_all_mod;
    data.T_mod_depth = T_mod_depth;
    
    %Here all functions in the nest start
    %_____________________________________%
    %%%%WTF_calc%%%%%%%%%
    function [qz_opt_all, data, N, L]= WTF_calc(data, numpar, k, indexs) 
        % here most of the work is done

        %initialize the output variables
        qz_opt_all=zeros(k,1);      % optimized vertical flow velocity
        fval_all=zeros(k,1);        % fminsearch objective function value
        exitflag_all=zeros(k,1);    % fminsearch exit condition
        bnds=zeros(k,2);            % fminserach outvariable of the bounds

        %_______getting the grid correct 
        L=data.z(end)-data.z(1);    % length of the domain
        %dx=L/100;                  % centimeter node spacing
        N=round(L/numpar.dx);       % number of nodes (integer!!!)
        z_FD=numpar.dx*-0.5:numpar.dx:L+0.5*numpar.dx; % depth of nodes
        node_z=sort([data.z(2:end-1)-numpar.dx/2 data.z(2:end-1)+numpar.dx/2]);  

        % find node number (ind) of temperature sensors
        for j=1:length(node_z)
            ind(j) = find((node_z(j)- z_FD).^2 == min((node_z(j)- z_FD).^2));
        end
        data.date_ind2=ind(1:2:end);

        %%???  In an assignment  A(I) = B, the number of elements in B and I must be the same.

        %_____________________________________
        % progressbar % Init single bar

        for i=1:k;
            index=indexs(:,i);
            if i>1;
                qzi=qz_opt_all(i-1);
            else
                qzi=numpar.qzi;
            end
            
            % set bounds for bound constrained optimisation
            bnds(i,1)=qzi-100/86400000*numpar.slope; % lower bound
            bnds(i,2)=qzi+100/86400000*numpar.slope; % upper bound

            [qz_opt_all(i), data.fval_all(i), data.exitflag_all(i) fmin_out(i)] = ...
                fminsearchbnd(@(qz) SSE(data,qz,indexs,i,k,N,L), qzi,bnds(i,1),bnds(i,2),optimset('TolX', numpar.tol,'TolFun',numpar.tol, 'MaxFunEvals', numpar.maxevaln,  'MaxIter' , numpar.maxevaln));

            progressbar(i/k) %display progressbar
        end
    end %end of function


    %%%%WTF_forward%%%%%%%%% 
    function [T_all_mod,T_mod_depth]=WTF_forward(data,qz_mod,jm,index, initial_temperature_profile)

        % Munz 2014
        Time=length(index)*numpar.dt; % time of evaluation (day) before: %fs*Tx; %total time [s] 
        T0t=data.T_all(index,end);       
        TLt=data.T_all(index,1);              

        % Transfer parameters affed
        TT=CN_Temp_forward(Time,numpar,thermpar,N,L,T0t,TLt,qz_mod,jm,initial_temperature_profile);
        T_all_mod=TT';%(T_node,:)';

        for i=1:length(data.date_ind2)
            T_mod_depth(i,:)=sum(TT(data.date_ind2(i):data.date_ind2(i)+1,:))*0.5;
        end
    end %end of function


    %%%%SSE____________________________________________%
    function err = SSE(data,qz,indexs,i,k,N,L)

        % adjust the length of the time window for the forward calculation
        if i==1;
            T0t=data.T_all(indexs(:,i),end);
            TLt=data.T_all(indexs(:,i),1);
            Tx=numel(indexs(:,i));
            Time=data.fs*Tx; %total time [s]
            qz_fix=ones(Tx,1).*qz;
         elseif i==k;
            T0t=data.T_all(indexs(:,i-1:i),end);
            TLt=data.T_all(indexs(:,i-1:i),1);
            Tx=numel(indexs(:,i-1:i));
            Time=data.fs*Tx; %total time [s]
            qz_fix=ones(Tx,1).*qz;
         else
            T0t=data.T_all(indexs(:,i-1:i+1),end);
            TLt=data.T_all(indexs(:,i-1:i+1),1);
            Tx=numel(indexs(:,i-1:i+1));
            Time=data.fs*Tx; %total time [s]
            qz_fix=ones(Tx,1).*qz;
         end

    %_______________________ 
        T_Mess=fliplr(data.T_all(:,2:end-1));
        jm=1; %Munz 2014
        TT=CN_Temp_forward(Time,numpar,thermpar,N,L,T0t,TLt,qz_fix,jm);

        for j=1:length(data.date_ind2)
            T_err(j,:)=sum(TT(data.date_ind2(j): data.date_ind2(j)+1,:))*0.5;
        end

        if i==1;
            err=sum(sum((T_Mess(indexs(:,i),1:end)'-T_err(:,:)).^2)); % for Tlog1 specify the nodes where the te,perature is evaluated
        elseif i==k;
            err=sum(sum((T_Mess(indexs(:,i),1:end)'-T_err(:,end/2+1:end)).^2));
        else
            err=sum(sum((T_Mess(indexs(:,i),1:end)'-T_err(:,end/3+1:end-end/3)).^2));
        end

    end %end of function


    function TT=CN_Temp_forward(Time,numpar,thermpar,N,L,T0t,TLt,qz_fix,jm,initial_temperature_profile);

        n=Time/numpar.dt;% number of data points
        D=thermpar.kfs/thermpar.rc;
        lambda=(D* numpar.dt)./(2*numpar.dx.^2);

        %initial and boundary condition
        TT=zeros(N+2,n);

        % % old initial condition based on linear interpolation between T0 and TL
        % T=interp1([1 N+2],[T0t(1) TLt(1)],1:N+2); %initial condition, linear interpolation between the boundary temperatures at t=0
        % T=T(:);
        % qz= qz_fix(1);

        % if k >0 initial condition is taken from the previous time step

        %new intial condition based on a steady state analystical solution
        z=numpar.dx*-0.5:numpar.dx:L+0.5*numpar.dx;
        T0=mean(T0t);
        TL=mean(TLt);
        % Munz 2014
        if jm==1
            qz=qz_fix(1);
            T=(exp(thermpar.rfcf/thermpar.kfs*qz*L*z./L)-1)./(exp(thermpar.rfcf/thermpar.kfs*qz*L)-1).*(TL-T0)+T0;
            T=T(:);
        else 
            qz=mean(qz_fix);%qz_fix(1);
            T = initial_temperature_profile(:);
            T=T(:);
        end

        a=qz.*thermpar.rfcf/thermpar.rc;
        alpha=(a.* numpar.dt)./(4.*numpar.dx);
        % generate the coefficient matrices
        LHS=zeros(N+2);
        RHS=zeros(N+2);

        %(maybe this could also be done with spdiags)
        for j=2:N+1
            LHS(j,j-1)=  -(lambda+alpha);
            LHS(j,j)  =  (1+2*lambda);
            LHS(j,j+1)= -(lambda-alpha);

            RHS(j,j-1)=   (lambda+alpha);
            RHS(j,j)  =   (1-2*lambda);
            RHS(j,j+1)=   (lambda-alpha);
        end

        LHS(1,1)=0.5; LHS(1,2)=0.5; RHS(1,1)=0.;            % T(0)=0
        LHS(N+2,N+1)=0.5; LHS(N+2,N+2)=0.5; RHS(N+2,N+2)=0; % T(L)=0

        for i=1:n
            % solve; find the right-hand side for the solve at interior points
            r=RHS*T;  % here could be space for optimizing T ( the one from the time step before) priot to calculating the next one

            % apply the boundary conditions
            r(1)=T0t(i);   % T(0,t)
            r(N+2)=TLt(i); % T(L)=const

            %  update TT
            T=LHS\r;
            TT(:,i)=T;
        end
    end %end of function

%____________________________________________
end %this is the end of the FLUX-BOT function
%__________________________________________________________

