% 定义文件名模式
filePattern = '*SCD.csv'; 
% 获取当前目录下所有匹配的文件
files = dir(filePattern);
% 检查文件数量是否正确
if length(files) ~= 22
    error('There are not exactly 22 files that match the pattern.');
end
% 初始化一个cell数组来存储每个矩阵
matrices = cell(22, 1);
% 循环遍历所有文件并读取它们
for i = 1:length(files)
    % 构造完整的文件名
    filename = files(i).name;
    fullPath = fullfile(pwd, filename);
    % 读取当前文件的矩阵
    matrices{i} = readmatrix(fullPath);
    % 检查矩阵大小是否正确
    if size(matrices{i}, 1) ~= 1056 || size(matrices{i}, 2) ~= 3
        error('File %s does not have the size of 1056x3.', filename);
    end
end
threeDArray = NaN(1056, 3, 22);
% 填充三维数组
for i = 1:22
    threeDArray(:,:,i) = matrices{i};
end
SCD=mean(threeDArray, 3, "omitnan");
writematrix(SCD,'INT_SCD.csv');
%%
% 定义文件名模式
clear;
filePattern = '*NC.csv'; 
% 获取当前目录下所有匹配的文件
files = dir(filePattern);
% 检查文件数量是否正确
if length(files) ~= 28
    error('There are not exactly 22 files that match the pattern.');
end
% 初始化一个cell数组来存储每个矩阵
matrices = cell(28, 1);
% 循环遍历所有文件并读取它们
for i = 1:length(files)
    % 构造完整的文件名
    filename = files(i).name;
    fullPath = fullfile(pwd, filename);
    % 读取当前文件的矩阵
    matrices{i} = readmatrix(fullPath);
    % 检查矩阵大小是否正确
    if size(matrices{i}, 1) ~= 1056 || size(matrices{i}, 2) ~= 3
        error('File %s does not have the size of 1056x3.', filename);
    end
end
threeDArray = NaN(1056, 3, 28);
% 填充三维数组
for i = 1:28
    threeDArray(:,:,i) = matrices{i};
end
NC=mean(threeDArray, 3, "omitnan");
writematrix(NC,'INT_NC.csv');