clear;clc;
%SCD
subj=[9005
9014
9020
9022
9024
9026
9027
9028
9037
9038
9039
9043
9050
9053
9054
9061
9062
9063
9065
9066
9074
9075];
max=120;%according to Neuroimage, 100 timepoints
for m=1:length(subj)
    cd /home/weissley/桌面/timeseries/
    file=readmatrix(['sub-',num2str(subj(m)),'_normal_timeseries.csv']);
    cd /home/weissley/桌面/timeseries/tau/
    acwvalue=cell(1056,1);
    for i=1:length(file(1,:))
        temp=[];
        ts=file(:,i);
        if ~isnan(file(1,i))
            [~,~,acf,lags]=acw(ts', 0.5, 0);
            temp=[acf(1:max)',lags(1:max)'];
            acwvalue{i}=temp;
        else
            acwvalue{i}=[NaN(max,1),NaN(max,1)];
        end
    end
    %计算1056个parcels的tau值
    tau=nan(1056,5);
    for i=1:1056
        % 假设 k 和 R_values 已经定义并赋值
        x = 0:(max-1);
        R = acwvalue{i}(:,1); % 你的观测数据
        if (~isnan(R(1)))%是有值的才算，没有的直接归nan
            % 初始参数估计值
            initialParams = [1, 0, 1]; % A=1, B=0, x=1
            ft=fittype('modelfunc(x, A, B, k)');
            % 尝试拟合数据
            try
                [fitParams, gof] = fit(x', R, ft, ...%默认非线性最小二乘法nonlinear least-squares fitting procedure
                    'StartPoint', initialParams, ...
                    'Lower', [0, -Inf, 0], ... % A和x必须非负
                    'Upper', [Inf, Inf, Inf]); % B可以是任意实数
            catch exception
                warning(exception.identifier,'%s', exception.message);
                fitParams = NaN(1, 3); % 如果有错误，设置fitParams为NaN
            end
        elseif (isnan(R(1)))
            fitParams.k = NaN;
            fitParams.A = NaN;
            fitParams.B = NaN;
        end
        % 跑完检查拟合参数是否为NaN
        if (isnan(fitParams.k))
            %warning('拟合未成功，返回NaN值');
        else
            tau(i,:)=[i,fitParams.A,fitParams.B,fitParams.k,gof.rsquare];
        end
    end
    writematrix(tau,['sub-',num2str(subj(m)),'_SCD_tau.csv']);
end
%%
%NC
subj=[9003
9004
9009
9015
9018
9021
9029
9031
9033
9034
9036
9041
9044
9045
9046
9047
9049
9051
9052
9055
9058
9059
9067
9068
9069
9071
9072
9076];
for m=1:length(subj)
    cd /home/weissley/桌面/timeseries/
    file=readmatrix(['sub-',num2str(subj(m)),'_normal_timeseries.csv']);
    cd /home/weissley/桌面/timeseries/tau/
    acwvalue=cell(1056,1);
    for i=1:length(file(1,:))
        temp=[];
        ts=file(:,i);
        if ~isnan(file(1,i))
            [~,~,acf,lags]=acw(ts', 0.5, 0);
            temp=[acf(1:max)',lags(1:max)'];
            acwvalue{i}=temp;
        else
            acwvalue{i}=[NaN(max,1),NaN(max,1)];
        end
    end
    %计算1056个parcels的tau值
    tau=nan(1056,5);
    for i=1:1056
        % 假设 k 和 R_values 已经定义并赋值
        x = 0:(max-1);
        R = acwvalue{i}(:,1); % 你的观测数据
        if (~isnan(R(1)))%是有值的才算，没有的直接归nan
            % 初始参数估计值
            initialParams = [1, 0, 1]; % A=1, B=0, x=1
            ft=fittype('modelfunc(x, A, B, k)');
            % 尝试拟合数据
            try
                [fitParams, gof] = fit(x', R, ft, ...%默认非线性最小二乘法nonlinear least-squares fitting procedure
                    'StartPoint', initialParams, ...
                    'Lower', [0, -Inf, 0], ... % A和x必须非负
                    'Upper', [Inf, Inf, Inf]); % B可以是任意实数
            catch exception
                warning(exception.identifier,'%s', exception.message);
                fitParams = NaN(1, 3); % 如果有错误，设置fitParams为NaN
            end
        elseif (isnan(R(1)))
            fitParams.k = NaN;
            fitParams.A = NaN;
            fitParams.B = NaN;
        end
        % 跑完检查拟合参数是否为NaN
        if (isnan(fitParams.k))
            %warning('拟合未成功，返回NaN值');
        else
            tau(i,:)=[i,fitParams.A,fitParams.B,fitParams.k,gof.rsquare];
        end
    end
    writematrix(tau,['sub-',num2str(subj(m)),'_NC_tau.csv']);
end