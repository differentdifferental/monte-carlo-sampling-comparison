function [samples, exec_time, accept_rate] = rejection_sampling_simple(n, T, varargin)
% REJECTION_SAMPLING_SIMPLE 使用接受-拒绝法生成高斯分布样本

tic;

% 常数设置
M = sqrt(2 * exp(1) / pi);  % 包围常数
sigma = sqrt(T);

samples = zeros(n, 1);
attempts = 0;
accepted = 0;

% 显示进度（对于大样本）
if n > 10000
    fprintf('    进度: ');
end

while accepted < n
    % 从拉普拉斯分布抽样（标准拉普拉斯）
    u = rand();
    y = -sign(u - 0.5) * log(1 - 2 * abs(u - 0.5));
    y_scaled = sigma * y;  % 调整尺度
    
    % 计算接受概率
    f = exp(-y_scaled^2/(2*T)) / sqrt(2*pi*T);  % 目标分布
    g = exp(-abs(y)) / 2;  % 标准拉普拉斯分布
    g_scaled = g / sigma;  % 调整尺度后的建议分布
    
    alpha = f / (M * g_scaled);
    
    attempts = attempts + 1;
    if rand() <= alpha
        accepted = accepted + 1;
        samples(accepted) = y_scaled;
        
        % 显示进度
        if n > 10000 && mod(accepted, floor(n/10)) == 0
            fprintf('%d%% ', round(100*accepted/n));
        end
    end
end

exec_time = toc;
accept_rate = n / attempts;

if nargin > 2 && strcmp(varargin{1}, 'verbose')
    if n > 10000
        fprintf('完成\n');
    end
    fprintf('    接受率: %.2f%% (尝试次数: %d)\n', 100*accept_rate, attempts);
    fprintf('    均值: %.4f, 标准差: %.4f (理论: %.4f)\n', ...
            mean(samples), std(samples), sqrt(T));
    fprintf('    执行时间: %.4f 秒\n', exec_time);
end
end