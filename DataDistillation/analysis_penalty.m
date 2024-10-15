function analysis_penalty(dataset,budget)

if dataset == "music"
    data = readtable("Datasets\yearpredictionmsd\YearPredictionMSD.txt");
    data = data{:,:};
    samples = length(data);
    target = data(:,1);
    data = data(:,2:end);
    training.count = 231857;
    validation.count = 231858;
    training.targets = target(1:training.count)';
    training.images = data(1:training.count,:)'; 
    training.size = size(training.images,1)';
    validation.targets = target(training.count+1:training.count+validation.count)';
    validation.images = data(training.count+1:training.count+validation.count,:)'; 
    test.targets = target(training.count+validation.count+1:end)';
    test.images = data(training.count+validation.count+1:end,:)'; 
    test.count = size(test.targets,2); 
    load("Datasets\yearpredictionmsd\Results\results_penalty_budget"+budget+".mat")
elseif dataset == "blog"
    data = readtable("Datasets\blogfeedback\blogData_train.csv");
    data = data{:,:};
    training.count = length(data);
    training.targets = data(:,end)';
    training.images = data(:,1:end-1)';
    training.size = size(training.images,1)';

    data2 = readtable("Datasets\blogfeedback\test_files\combined_data.csv");
    data2 = data2{:,:}; %7624         281
    samples2 = length(data2); %7624 
    target2 = data2(:,end);
    data2 = data2(:,1:end-1);
    validation.count = fix(samples2*(1/7)); 
    validation.targets = target2(1:validation.count)';
    validation.images = data2(1:validation.count,:)'; 
    test.targets = target2(validation.count+1:end)';
    test.images = data2(validation.count+1:end,:)'; 
    test.count = size(test.targets,2); 
    load("Datasets\blogfeedback\Results\results_penalty_budget"+budget+".mat")
end

rr = round(training.count*(budget/100)); %budget

iter_outer_list = otp_pen.iter_outer_list;
itermax_pen = otp_pen.iter;
sol_cell_list = otp_pen.cell;

iter_outer_ = sum(iter_outer_list(1:itermax_pen));
of_list = zeros(iter_outer_,1);
of_pen_list = zeros(iter_outer_,1);
rr_round_list = zeros(iter_outer_,1);
of_val_list = zeros(iter_outer_,1);
RMSE_val_list = zeros(iter_outer_,1);
MAPE_val_list = zeros(iter_outer_,1);

sum_ = 0;

for iter=1:itermax_pen

    iter_outer = iter_outer_list(iter);
    sol_cell = sol_cell_list{iter};
    sol_cell = sol_cell.sol;
    
    for k=1:iter_outer

        sol_cell_k = sol_cell{k};
        v = sol_cell_k{1};
        W = sol_cell_k{2};
        b = sol_cell_k{3};
        eps_pen = sol_cell_k{4};
        
        of = sum(sum((W*test.images+b-test.targets).^2,1))/(2*test.count);
        of_pen = of + sum(v.*(1-v))/eps_pen;

        v_round = round(v);
        of_val = sum(sum((W*validation.images+b-validation.targets).^2,1))/(2*validation.count);
        RMSE_val = sqrt(sum((W*validation.images+b-validation.targets).^2)/validation.count);

        of_list(k+sum_) = of;
        of_pen_list(k+sum_) = of_pen;
        rr_round_list(k+sum_) = sum(v_round);
        of_val_list(k+sum_) = of_val;
        RMSE_val_list(k+sum_) = RMSE_val;

    end

    sum_ = sum_ + iter_outer;

end

T = table(of_list,of_pen_list,rr_round_list,of_val_list,RMSE_val_list,rr*ones(iter_outer_,1));
if dataset == "music"
    writetable(T,"Datasets\yearpredictionmsd\Results\analysis_penalty_budget"+budget+".csv",'Delimiter',';')
elseif dataset == "blog"
    writetable(T,"Datasets\blogfeedback\Results\analysis_penalty_budget"+budget+".csv",'Delimiter',';') 
end
end
























