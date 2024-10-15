function DataDistillationRegression_penalty(dataset,budget,iter_outer)

format long
c = 1e2;
if dataset == "music" 
    learning_rate_outer = 1e-3;
    data = readtable("Datasets\yearpredictionmsd\YearPredictionMSD.txt");
    data = data{:,:};
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
    e_min = 1e-5; 
elseif dataset == "blog"
    learning_rate_outer = 1e-5;
    data = readtable("Datasets\blogfeedback\blogData_train.csv");
    data = data{:,:};
    training.count = length(data);
    training.targets = data(:,end)';
    training.images = data(:,1:end-1)';
    training.size = size(training.images,1)';

    data2 = readtable("Datasets\blogfeedback\test_files\combined_data.csv");
    data2 = data2{:,:}; %7624        
    samples2 = length(data2); %7624 
    target2 = data2(:,end);
    data2 = data2(:,1:end-1);
    validation.count = fix(samples2*(1/7)); 
    validation.targets = target2(1:validation.count)';
    validation.images = data2(1:validation.count,:)'; 
    test.targets = target2(validation.count+1:end)';
    test.images = data2(validation.count+1:end,:)'; 
    test.count = size(test.targets,2); 
    e_min = 1e-7; %1e-6; 
end

rr = round(training.count*(budget/100)); %budget
dd = ones(training.count,1);
bb = ones(training.count,1);
ll = zeros(training.count,1);
uu = ones(training.count,1);
eps = 1e-10;  
t_U = +Inf;
t_L = -Inf;
maxiter = 1e3;

%penalty method parameteres/initialization
eps_pen = 10e9;
itermax_pen = 10; 
beta = nthroot(e_min/eps_pen,itermax_pen);    
iter_outer_list = fix(iter_outer/itermax_pen)*ones(1,itermax_pen);  

%Initialization 
v = ones(1,training.count)*(rr/training.count); 
V = sum(v,2); %rr
otp_pen_cell = cell(1,itermax_pen);

for iter=1:itermax_pen

    iter_outer = iter_outer_list(iter);
    sol_cell = cell(1,iter_outer);

    for k=1:iter_outer
        x_ = sum(v.*training.images,2)./V;
        y_ = sum(v.*training.targets,2)./V;
        
        x_hat = training.images - x_;
        y_hat = training.targets - y_;

        C_XY = ((v.*y_hat)*x_hat')/training.count;
        C_X = ((v.*x_hat)*x_hat')/training.count;
        
        M1 = C_X + c*eye(training.size);
    
        W = (mldivide(M1',C_XY'))';
    
        %LL
        b = y_ - W*x_; 
        z = test.images - x_;
    
        a = mldivide(M1,z);
        A = mldivide(M1,x_hat);
        M2 = - C_XY*A + y_hat;

        %stochastic gradient #computational cost
        training_rand_count = 600;
        rand_index = randperm(training.count,training_rand_count); 
        x_hat_rand = x_hat(:,rand_index)';
        add1 = (W*(test.images - x_) + y_ - test.targets) .* ( reshape(M2(:,rand_index),[1,1,training_rand_count]).*permute(reshape(x_hat_rand*a,[1,training_rand_count,test.count]),[1,3,2]));
        add1 = sum(add1,[1,2]); 
        add1 = add1(:)'/test.count;
        add1_full = zeros(1,training.count);
        add1_full(1,rand_index) = add1;

        test_images_avg = sum(test.images,2)./test.count;
        test_targets_avg = sum(test.targets,2)./test.count;
        F1 = (W*(test_images_avg - x_) + y_ - test_targets_avg)';
        F2 = y_hat - W*x_hat;
        add2 = (F1*F2)./V;
        gradJ_v = add1_full+add2  +  ((1-(2*v))./eps_pen);

        v = v - learning_rate_outer*gradJ_v; 

        T = sort(union((v-sum(uu)),v));
        v = kiwiel(T,dd,v',bb,rr,ll,uu,eps,t_U,t_L,maxiter);
        V = sum(v,2); 

        sol_cell{k} = {v,W,b,eps_pen};

    end

    otp.sol = sol_cell;

    tol = 1e-2; 
    v_0 = v-0; 
    v_1 = 1-v; 
    v_min = min(v_0,v_1); 
    v_min_inf = max(v_min); 
    dist = max(v_min_inf);

    otp_pen_cell{iter} = otp;
    if dist >= tol 
        eps_pen = beta*eps_pen; 
    else
        break
    end      
    
end
otp_pen.cell = otp_pen_cell;
otp_pen.iter_outer_list = iter_outer_list;
otp_pen.iter = iter;
otp_pen.v_final = v;
of = sum(sum((W*test.images+b-test.targets).^2,1))/(2*test.count);
otp_pen.of_final = of;
otp_pen.v_final_sum = sum(v);
otp_pen.v_find = find(v);
otp_pen.W = W;
otp_pen.b = b;

%save results 
if dataset == "music"
    save("Datasets\yearpredictionmsd\Results\results_penalty_budget"+budget+".mat",'otp_pen', '-v7.3')
elseif dataset == "blog"
    save("Datasets\blogfeedback\Results\results_penalty_budget"+budget+".mat",'otp_pen', '-v7.3')
end
end
