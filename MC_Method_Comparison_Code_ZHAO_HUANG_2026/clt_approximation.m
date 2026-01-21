function [samples, exec_time] = clt_approximation(n, T, varargin)
% CLT_APPROXIMATION_SIMPLE CLT近似法
tic;

% 使用12个均匀分布之和（向量化计算，提高效率）
% 生成n×12的均匀随机数矩阵
u_matrix = rand(n, 12);
% 计算每行的和，减去6得到近似标准正态
z = sum(u_matrix, 2) - 6;
% 调整方差
samples = sqrt(T) * z;

exec_time = toc;

if nargin > 2 && strcmp(varargin{1}, 'verbose')
    fprintf('    使用12个均匀分布之和（向量化）\n');
    fprintf('    均值: %.4f, 标准差: %.4f (理论: %.4f)\n', ...
            mean(samples), std(samples), sqrt(T));
    fprintf('    执行时间: %.4f 秒\n', exec_time);
end
end