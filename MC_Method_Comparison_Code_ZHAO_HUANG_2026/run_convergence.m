function convergence_results = run_convergence(params)
% RUN_CONVERGENCE_EXPERIMENT 运行收敛性实验

% 样本量序列（对数尺度）
sample_sizes = round(logspace(2, 6, 20));  % 100 到 1,000,000
n_sizes = length(sample_sizes);
T = 2.0;  % 固定温度进行收敛性测试
theory_entropy = 0.5 * log(2 * pi * exp(1) * T);

% 初始化结果存储
methods = {'BoxMuller', 'Rejection', 'Metropolis', 'CLT'};
n_methods = length(methods);

for m_idx = 1:n_methods
    method = methods{m_idx};
    fprintf('  测试方法: %s... ', method);
    
    errors = zeros(n_sizes, 1);
    times = zeros(n_sizes, 1);
    
    for s_idx = 1:n_sizes
        n = sample_sizes(s_idx);
        
        % 调整MCMC参数
        if strcmp(method, 'Metropolis')
            mcmc_total = round(n * 1.2);  % 总样本数
            burn_in = round(mcmc_total * 0.2);  % 20%燃烧期
            [samples, exec_time] = metropolis(mcmc_total, T, burn_in);
        else
            % 使用eval函数调用对应的方法
            switch method
                case 'BoxMuller'
                    [samples, exec_time] = box_muller(n, T);
                case 'Rejection'
                    [samples, exec_time, ~] = rejection_sampling(n, T);
                case 'CLT'
                    [samples, exec_time] = clt_approximation(n, T);
            end
        end
        
        % 计算熵和误差
        entropy_val = calculate_entropy(samples, T);
        errors(s_idx) = abs(entropy_val - theory_entropy) / theory_entropy;
        times(s_idx) = exec_time;
    end
    
    % 存储结果
    convergence_results.(method).sample_sizes = sample_sizes;
    convergence_results.(method).errors = errors;
    convergence_results.(method).times = times;
    convergence_results.(method).method_name = method;
    
    fprintf('完成\n');
end
end