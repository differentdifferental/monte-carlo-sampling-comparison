function [samples, exec_time] = box_muller(n, T, varargin)
% BOX_MULLER_FIXED 使用Box-Muller变换生成高斯分布样本
% 修正了数组越界问题

tic;

% 需要生成的对数（一次生成一对）
n_pairs = ceil(n/2);

% 生成均匀分布随机数
u1 = rand(n_pairs, 1);
u2 = rand(n_pairs, 1);

% Box-Muller变换
r = sqrt(-2 * log(u1));
theta = 2 * pi * u2;
z1 = r .* cos(theta);
z2 = r .* sin(theta);

% 合并样本
z = [z1; z2];

% 取前n个并调整方差
samples = sqrt(T) * z(1:n);

exec_time = toc;

if nargin > 2 && strcmp(varargin{1}, 'verbose')
    fprintf('  Box-Muller变换:\n');
    fprintf('    样本数: %d, 实际生成了 %d 个样本\n', n, length(z));
    fprintf('    均值: %.4f, 标准差: %.4f (理论: %.4f)\n', ...
            mean(samples), std(samples), sqrt(T));
    fprintf('    执行时间: %.4f 秒\n', exec_time);
end
end