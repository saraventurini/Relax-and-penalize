function analysis(dataset,budget,iter_outer)
c = 1e2;
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
    load("Datasets\yearpredictionmsd\Results\results_budget"+budget+".mat")
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
    load("Datasets\blogfeedback\Results\results_budget"+budget+".mat")
end

rr = round(training.count*(budget/100)); %budget
sol_cell = otp.sol; 

of_list = zeros(iter_outer,1);
of_round_list = zeros(iter_outer,1);
rr_round_list = zeros(iter_outer,1);
of_val_list = zeros(iter_outer,1);
of_round_val_list = zeros(iter_outer,1);

RMSE_val_list = zeros(iter_outer,1); %Mean-Square-Error (RMSE)
RMSE_round_val_list = zeros(iter_outer,1);
MAPE_val_list = zeros(iter_outer,1); %Mean Absolute Percentage Error (MAPE)
MAPE_round_val_list = zeros(iter_outer,1);

for k=1:iter_outer

    sol_cell_k = sol_cell{k};
    v = sol_cell_k{1};
    W = sol_cell_k{2};
    b = sol_cell_k{3};

    of = sum(sum((W*test.images+b-test.targets).^2,1))/(2*test.count);

    v_round = round(v);
    V_round = sum(v_round,2);
    x_ = sum(v_round.*training.images,2)./V_round;
    y_ = sum(v_round.*training.targets,2)./V_round;
    x_hat = training.images - x_;
    y_hat = training.targets - y_;
    C_XY = ((v_round.*y_hat)*x_hat')/training.count;
    C_X = ((v_round.*x_hat)*x_hat')/training.count;
    M1 = C_X + c*eye(training.size);
    W_round = (mldivide(M1',C_XY'))';
    b_round = y_ - W_round*x_;
    of_round = sum(sum((W_round*test.images+b_round-test.targets).^2,1))/(2*test.count);
    
    of_val = sum((W*validation.images+b-validation.targets).^2)/(2*validation.count);
    of_round_val = sum((W_round*validation.images+b_round-validation.targets).^2)/(2*validation.count);

    RMSE_val = sqrt(sum((W*validation.images+b-validation.targets).^2)/validation.count);
    RMSE_round_val = sqrt(sum((W_round*validation.images+b_round-validation.targets).^2)/validation.count);
    MAPE_val = 100*(sum( abs(W*validation.images+b-validation.targets)./validation.targets)/validation.count);
    MAPE_round_val = 100*(sum( abs(W_round*validation.images+b_round-validation.targets)./validation.targets)/validation.count);
    
    of_list(k) = of;
    of_round_list(k) = of_round;
    rr_round_list(k) = sum(v_round);
    of_val_list(k) = of_val;
    of_round_val_list(k) = of_round_val;
    RMSE_val_list(k) = RMSE_val;
    RMSE_round_val_list(k) = RMSE_round_val;

end

T = table(of_list,of_round_list,rr_round_list,of_val_list,of_round_val_list,RMSE_val_list,RMSE_round_val_list,rr*ones(iter_outer,1));
if dataset == "music"
    writetable(T,"Datasets\yearpredictionmsd\Results\analysis_budget"+budget+".csv",'Delimiter',';')
elseif dataset == "blog"
    writetable(T,"Datasets\blogfeedback\Results\analysis_budget"+budget+".csv",'Delimiter',';') 
end
end































