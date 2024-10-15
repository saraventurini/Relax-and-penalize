# Relax-and-penalize
This repository contains the codes of the paper "Relax and penalize: a new bilevel approach to mixed-binary hyperparameter optimization" by Marianna De Santis, Jordan Frecon-Deloir, Francesco Rinaldi, Saverio Salzo, Martin Schmidt, Sara Venturini.

## Two machine-learning applications 
The two folders correspond to the Matlab Codes concerning the two applications included in the paper (Section 5.1): Group Lasso Structure and Data Distillation. 

### Group Lasso Structure (Subsection 5.1)
#### Matlab codes:
Extention to the optimization of lambda of the codes in: https://github.com/JordanFrecon/BiGLasso

- BiGLasso-master_lambda: a folder that contains all the scripts concerning the relax-and-rounding method.
    - demo_BiGLasso_lambda.m: script to run the experiments over the synthetic datasets with the relax-and-rounding method. 
    - BiGLasso_lambda.m: script to run the relax-and-rounding method
    - optimGS_setting_lambda.m: script defined different functions used in the other scripts
    - optimBLGS_setting_lambda.m: script to solve the upper-level problem
    - optimGS_hypergradient_v2_lambda.m: script to compute the hypergradient of the upper-level problem in reverse mode
    - optimGS_lower_lambda.m: script to solve the lower-level problem
- BiGLasso-master_penalty_lambda: a folder that contains all the scripts concerning the relax-and-penalize method. 
    - demo_BiGLasso_penalty_lambda.m: script to run the experiments over the synthetic datasets with the relax-and-penalize method. 
    - BiGLasso_penalty_lambda.m: script to run the relax-and-penalize method
    - optimGS_setting_penalty_lambda.m: script defined different functions used in the other scripts
    - optimBLGS_setting_penalty_lambda.m: script to solve the upper-level problem
    - optimGS_hypergradient_v2_penalty_lambda.m: script to compute the hypergradient of the upper-level problem in reverse mode
    - optimGS_lower_penalty_lambda.m: script to solve the lower-level problem
- tables_overleaf.m: script to calculate the quantities (test and reconstruction error) achieved by the two methods and reported in Table 1 and Table 2. They are saved in the folder "Plots_synthesizeDataset"
  
#### Datasets:

We conduct experiments on synthetic datasets. Details are contained in the Appendix of the paper.
- synthesizeDataset.m: script to generate one synthetic dataset
- synthesizeDataset_save.m: script to generate all the synthetic datasets of the analysis in the paper. We generate 10 instances of inequal and random group structures, for a ∈ {0.1, 0.2, 0.3, 0.4, 0.5}. They are saved in the folder "synthesizeDataset", in order to run the two methods on the same instances. 

### Data Distillation (Subsection 5.2)
#### Matlab codes:
- run_script.m: script to run the experiments over the two real datasets (music and farm), for three percentages of data distillation (10%, 20%, 30%), with the relax-and-rounding method and the relax-and-penalize.
- DataDistillationRegression.m: script to run the relax-and-rounding algorithm 
- DataDistillationRegression_penalty.m: script to run the relax-and-penalize algorithm
- kiwiel.m: script to perform the Kiwiel algorithm to project the solution over the region defined by the knapsack constraint.  
- analysis.m: script to calculate the quantities reposted in Table 3 for each iteration of the relax-and-rounding algorithm 
- analysis_penalty.m: script to calculate the quantities reposted in Table 3 for each iteration of the relax-and-penalize algorithm
- plots.m: script to create the corresponding plots of the quantities calculated in analysis.m
- plots_penalty.m: script to create the corresponding plots of the quantities calculated in analysis_penalty.m
- tables_overleaf.m: script to create Table 3, where we report the quantities achieved by the two methods after 1e3 external iterations.

#### Datasets:
We perform experiments over two real datasets:
- music: download the dataset at https://archive.ics.uci.edu/dataset/203/yearpredictionmsd 
- blog: download the dataset at https://archive.ics.uci.edu/dataset/304/blogfeedback.
The test data spanning from February to March 2012 are contained in different CSV files and merged in one file cvs through the script union_csv.m <br>

The data are loaded in the dataset folder. <br>
Detailed information on the datasets are included in the Appendix of the paper. 




