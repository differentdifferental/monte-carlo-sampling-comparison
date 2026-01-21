%% ================================================================
%% 蒙特卡洛抽样方法比较研究 - 主程序
%% 修正字段名问题，确保程序正常运行
%% ================================================================

clear; clc; close all;
addpath(genpath(pwd));

% 设置全局参数
params.N = 50000;                  % 样本数
params.MCMC_total = 60000;         % MCMC总样本数（含燃烧期）
params.burn_in = 10000;            % MCMC燃烧期样本数
params.T_vec = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0];  % 温度范围
params.n_trials = 10;              % 每种方法重复次数
params.random_seed = 42;           % 随机种子（确保结果可重复）

% 固定随机种子
rng(params.random_seed);

% 初始化结果存储结构
results = struct();

% 记录开始时间
fprintf('开始蒙特卡洛抽样实验...\n');
fprintf('样本数: %d, 温度点: %d个, 重复次数: %d\n\n', ...
        params.N, length(params.T_vec), params.n_trials);

%% 辅助函数：生成有效的结构体字段名
function field_name = get_field_name(T)
    % 将温度转换为有效的字段名（不能包含点号）
    % 例如：0.5 -> "T0_5", 1.0 -> "T1_0", 2.5 -> "T2_5"
    str = num2str(T);
    % 将点号替换为下划线
    str = strrep(str, '.', '_');
    field_name = ['T', str];
end

%% 主实验循环：对每个温度点进行抽样比较
for t_idx = 1:length(params.T_vec)
    T = params.T_vec(t_idx);
    field_name = get_field_name(T);
    
    fprintf('\n温度 T = %.1f:\n', T);
    fprintf('理论熵 S_theory = %.6f\n', 0.5*log(2*pi*exp(1)*T));
    
    % 初始化当前温度的结果存储
    temp_results = struct();
    
    % 方法1: Box-Muller变换
    fprintf('  1. Box-Muller变换...\n');
    [temp_results.BoxMuller.samples, temp_results.BoxMuller.time] = ...
        box_muller(params.N, T);
    temp_results.BoxMuller.entropy = calculate_entropy(...
        temp_results.BoxMuller.samples, T);
    
    % 方法2: 接受-拒绝法
    fprintf('  2. 接受-拒绝法...\n');
    [temp_results.Rejection.samples, temp_results.Rejection.time, ...
     temp_results.Rejection.accept_rate] = ...
        rejection_sampling(params.N, T);
    temp_results.Rejection.entropy = calculate_entropy(...
        temp_results.Rejection.samples, T);
    
    % 方法3: Metropolis算法
    fprintf('  3. Metropolis算法...\n');
    [temp_results.Metropolis.samples, temp_results.Metropolis.time] = ...
        metropolis(params.MCMC_total, T, params.burn_in);
    temp_results.Metropolis.entropy = calculate_entropy(...
        temp_results.Metropolis.samples, T);
    
    % 方法4: CLT近似法
    fprintf('  4. CLT近似法...\n');
    [temp_results.CLT.samples, temp_results.CLT.time] = ...
        clt_approximation(params.N, T);
    temp_results.CLT.entropy = calculate_entropy(...
        temp_results.CLT.samples, T);
    
    % 存储当前温度结果
    results.(field_name) = temp_results;
end

%% 重复实验：统计稳定性
fprintf('\n进行重复实验以评估稳定性...\n');
stability_results = run_stability(params);

%% 收敛性实验：不同样本量的表现
fprintf('\n进行收敛性实验...\n');
convergence_results = run_convergence(params);

%% 生成报告和图表
fprintf('\n生成报告和图表...\n');
generate_report(results, stability_results, convergence_results, params);

fprintf('\n实验完成！结果已保存到output文件夹。\n');