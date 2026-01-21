function [samples, exec_time] = metropolis(n_total, T, burn_in, varargin)
% METROPOLIS_SIMPLE Metropolis算法

tic;

sigma_proposal = sqrt(T);  % 提议分布的标准差
n_effective = n_total - burn_in;
samples = zeros(n_effective, 1);
current = randn() * sqrt(T);  % 初始状态

for i = 1:n_total
    % 提议新状态
    candidate = current + sigma_proposal * randn();
    
    % 计算接受概率（对数形式）
    log_alpha = -(candidate^2 - current^2) / (2 * T);
    
    % 接受或拒绝
    if log(rand()) <= log_alpha
        current = candidate;
    end
    
    % 存储燃烧期后的样本
    if i > burn_in
        samples(i - burn_in) = current;
    end
end

exec_time = toc;

if nargin > 3 && strcmp(varargin{1}, 'verbose')
    fprintf('    有效样本: %d (总样本: %d, 燃烧期: %d)\n', n_effective, n_total, burn_in);
    fprintf('    均值: %.4f, 标准差: %.4f (理论: %.4f)\n', ...
            mean(samples), std(samples), sqrt(T));
    fprintf('    执行时间: %.4f 秒\n', exec_time);
end
end