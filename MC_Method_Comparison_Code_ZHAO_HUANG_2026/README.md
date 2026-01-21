# 蒙特卡洛抽样方法比较研究：谐振子系统信息熵计算

[![MATLAB](https://img.shields.io/badge/MATLAB-R2025b-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> 西安交通大学物理学院本科研究项目
> 
> 对应论文：《蒙特卡洛抽样方法比较研究——以谐振子系统信息熵计算为例》

## 📖 项目概述

本项目系统比较了四种经典蒙特卡洛抽样方法在谐振子系统信息熵计算中的性能表现：

- **Box-Muller变换法**：精确数学变换方法
- **接受-拒绝法**：通用性强的包络抽样方法  
- **Metropolis算法**：马尔可夫链蒙特卡洛方法
- **CLT近似法**：基于中心极限定理的快速近似方法

通过构建多维度量化评估体系（精确性、效率、稳定性、收敛性、通用性），为蒙特卡洛方法在实际科学计算问题中的选择提供数据驱动的决策依据。

## 📊 核心发现

| 方法 | 平均相对误差 | 平均执行时间 | 稳定性 | 推荐场景 |
|------|-------------|-------------|--------|----------|
| Box-Muller变换 | 0.122% | 2.49 ms | 0.0037 | 精确高斯分布抽样 |
| 接受-拒绝法 | 0.095% | 8.00 ms | 0.0028 | 高精度通用分布抽样 |
| Metropolis算法 | 0.415% | 4.41 ms | 0.0075 | 复杂/高维分布抽样 |
| CLT近似法 | 0.263% | 3.28 ms | 0.0030 | 快速工程近似 |

## 🗂️ 项目结构

```
monte-carlo-sampling-comparison/
├── main_program.m              # 主程序入口
├── box_muller.m               # Box-Muller变换实现
├── rejection_sampling.m       # 接受-拒绝法实现
├── metropolis.m               # Metropolis算法实现
├── clt_approximation.m        # CLT近似法实现
├── calculate_entropy.m        # 信息熵计算函数
├── run_stability.m           # 稳定性实验
├── run_convergence.m         # 收敛性实验
├── generate_report.m         # 报告生成器
├── output/                   # 输出文件夹（自动生成）
│   ├── distribution_comparison.png       # 分布对比图
│   ├── entropy_error_comparison.png      # 误差对比图
│   ├── execution_time_comparison.png     # 执行时间图
│   ├── stability_errorbar.png           # 稳定性误差条图
│   ├── convergence_analysis.png         # 收敛性分析图
│   └── experiment_report.txt            # 实验报告
└── README.md                 # 本文档
```

## 🚀 快速开始

### 环境要求
- MATLAB R2016b 或更高版本
- 建议内存：4GB 以上

### 运行步骤
1. 克隆或下载本仓库
2. 在MATLAB中打开项目文件夹
3. 运行主程序：
   ```matlab
   main_program
   ```
4. 查看 `output/` 文件夹中的结果

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 👥 作者

- **赵汗青** - 主要开发者
- **黄夕航** - 合作开发者

---
⭐️ 如果这个项目对你有帮助，请给我们一个 Star！
