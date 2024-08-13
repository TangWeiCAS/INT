clear;clc;
subj=9047;
file=readmatrix(['sub-',num2str(subj(1)),'_normal_timeseries.csv']);
acwvalue=cell(1056,1);
for i=1:length(file(1,:))
    temp=[];
    ts=file(:,i);
    if ~isnan(file(1,i))
        [~,~,acf,lags]=acw(ts', 0.5, 0);
        temp=[acf(2:101)',lags(2:101)'];
        acwvalue{i}=temp;
    else
        acwvalue{i}=[NaN(100,1),NaN(100,1)];
    end
end
%计算1056个parcels的tau值
tau=nan(1056,5);
for i=1:1056
    % 假设 k 和 R_values 已经定义并赋值
    x = 1:100;
    R = acwvalue{i}(:,1); % 你的观测数据
    if (~isnan(R(1)))%是有值的才算，没有的直接归nan
        % 初始参数估计值
        initialParams = [1, 0, 1]; % A=1, B=0, x=1
        ft=fittype('modelfunc(k, A, B, x)');
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
        warning('拟合未成功，返回NaN值');
    else %先不输出了，直接保存
%         % 输出拟合参数
%         disp('拟合参数:');
%         disp(['    A: ', num2str(fitParams.A)]);
%         disp(['    B: ', num2str(fitParams.B)]);
%         disp(['    k: ', num2str(fitParams.k)]);
% 
%         % 计算拟合优度
%         disp('拟合优度:');
%         disp(['    R-squared: ', num2str(gof.rsquare)]);
        tau(i,:)=[i,fitParams.A,fitParams.B,fitParams.k,gof.rsquare];
    end
end
writematrix(tau,['sub-',num2str(subj(1)),'_tau.csv']);