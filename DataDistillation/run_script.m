%run experiments for 2 real datasets (music, blog), 3 distillation
%percentage (10,20,30), method with rounding and method with penalization

dataset_list = ["music","blog"]; %datasets
budget_list = [10,20,30]; %distillation percentage
iter_outer = 1000;

%method with rounding
for dataset = dataset_list 
    for budget = budget_list 
        DataDistillationRegressionRegression(dataset,budget,iter_outer)
        analysis(dataset,budget,iter_outer)
        plots(dataset,budget)
    end
end

%method with penalization
for dataset = dataset_list 
    for budget = budget_list 
        DataDistillationRegressionRegression_penalty(dataset,budget,iter_outer)
        analysis_penalty(dataset,budget)
        plots_penalty(dataset,budget)
    end
end
