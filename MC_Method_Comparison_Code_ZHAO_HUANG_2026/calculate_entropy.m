function entropy = calculate_entropy(samples, T, varargin)
% CALCULATE_ENTROPY_SIMPLE 计算信息熵
% 设置直方图参数
n_bins = 100;
sigma = sqrt(T);
x_min = -4 * sigma;
x_max = 4 * sigma;

% 计算直方图
[counts, bin_edges] = histcounts(samples, n_bins, 'BinLimits', [x_min, x_max]);
bin_width = bin_edges(2) - bin_edges(1);

% 估计概率密度
n_samples = length(samples);
pdf_estimate = counts / (n_samples * bin_width);

% 计算箱中心点
bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;

% 数值积分计算熵
valid_idx = pdf_estimate > 0;
if any(valid_idx)
    entropy = -sum(pdf_estimate(valid_idx) .* log(pdf_estimate(valid_idx))) * bin_width;
else
    entropy = 0;
end

if nargin > 2 && strcmp(varargin{1}, 'verbose')
    theory_entropy = 0.5 * log(2 * pi * exp(1) * T);
    fprintf('    估计熵: %.6f, 理论熵: %.6f\n', entropy, theory_entropy);
    fprintf('    相对误差: %.4f%%\n', 100*abs(entropy - theory_entropy)/theory_entropy);
end
end