function stability_results = run_stability(params)
% RUN_STABILITY_EXPERIMENT 运行稳定性实验

% 辅助函数：生成有效的结构体字段名
function field_name = get_field_name(T)
    str = num2str(T);
    str = strrep(str, '.', '_');
    field_name = ['T', str];
end

% 初始化结果存储
stability_results = struct();
methods = {'BoxMuller', 'Rejection', 'Metropolis', 'CLT'};
n_methods = length(methods);
n_temps = length(params.T_vec);

% 对每个温度点
for t_idx = 1:n_temps
    T = params.T_vec(t_idx);
    field_name = get_field_name(T);
    
    fprintf('  温度 T=%.1f: ', T);
    
    % 对每种方法
    for m_idx = 1:n_methods
        method = methods{m_idx};
        entropies = zeros(params.n_trials, 1);
        times = zeros(params.n_trials, 1);
        
        % 重复运行
        for trial = 1:params.n_trials
            % 使用不同的随机种子确保独立性
            rng(params.random_seed + trial * 100);
            
            % 调用相应的抽样方法
            switch method
                case 'BoxMuller'
                    [samples, exec_time] = box_muller(params.N, T);
                    entropy_val = calculate_entropy(samples, T);
                    
                case 'Rejection'
                    [samples, exec_time, ~] = rejection_sampling(params.N, T);
                    entropy_val = calculate_entropy(samples, T);
                    
                case 'Metropolis'
                    [samples, exec_time] = metropolis(params.MCMC_total, T, params.burn_in);
                    entropy_val = calculate_entropy(samples, T);
                    
                case 'CLT'
                    [samples, exec_time] = clt_approximation(params.N, T);
                    entropy_val = calculate_entropy(samples, T);
            end
            
            entropies(trial) = entropy_val;
            times(trial) = exec_time;
        end
        
        % 存储结果
        stability_results.(field_name).(method).entropies = entropies;
        stability_results.(field_name).(method).times = times;
        stability_results.(field_name).(method).mean_entropy = mean(entropies);
        stability_results.(field_name).(method).std_entropy = std(entropies);
        stability_results.(field_name).(method).mean_time = mean(times);
        stability_results.(field_name).(method).std_time = std(times);
    end
    fprintf('完成\n');
end
end