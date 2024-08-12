function [acw_0, acw_50, acf, lags] = acw(x, fs, isplot)
[acf, lags] = xcorr(x, 'coeff');
index = find(acf == 1); % Get rid of the left-side（1就是正中间那一组的自相关系数，左右对称，从右边开始就是只考虑lag=0开始，不考虑负数）
acf = acf(index:end);
lags = lags(index:end);%找到总共多少个系数，以及多少个对应的lag

[~, ACW_50_i] = max(acf<=0.5);% [r值，index（lag）]
acw_50 = ACW_50_i / fs; % 本来是第几个lag之后，除以fs就是延迟几秒后自相关开始跌破0.5
[~, ACW_0_i] = max(acf<=0); % [r值，index（lag）]
acw_0 = ACW_0_i / fs; % 本来是第几个lag之后，除以fs就是延迟几秒后自相关开始跌破0
lags = lags / fs; % 把lag（该函数是按照数列来计算的，只记录整数索引）转化为秒数，便于绘图

if isplot % TRUE开始绘图
    plot(lags,acf,'k')
    xlim([0 max(lags)])%画完了x轴（带坐标）和y轴
    hold on %画结果区域
    area(lags(1:ACW_50_i), acf(1:ACW_50_i),'FaceColor','r','FaceAlpha',0.3); %降到0.5要多久
    area(lags(1:ACW_0_i), acf(1:ACW_0_i),'FaceColor','m','FaceAlpha',0.3); %降到0要多久
    title(['ACW-0 = ', num2str(acw_0, '%.1f'), ' ACW-50 = ', num2str(acw_50, '%.1f')]) %把参数全部标注上，画在图里
    xlabel('Lags (s)')
    ylabel('Autocorrelation')
end
end