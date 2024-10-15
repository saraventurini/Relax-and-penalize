
    addpath '.\BiGLasso-master_lambda\BiGLasso-master\_functions\_optim'

    N = 20;           %Number of samples
    P = 100;          %Number of features
    L = 10;           %Number of groups

    %parameters
    T = 500;         %Number of tasks 
    S = 1;           %Number of non-zero groups per task
    ssynth.groups.distrib = 'rand'; %'equal','inequal','rand'
    ssynth.noise.param           = [0 .2];
    ssynth.features.a     = 0.2; 

    %upper level objective function
    obj = @(vary,varX,varw) ( .5*sum(sum((vary - squeeze(sum(bsxfun(@times,permute(varX,[2,1,3]),reshape(varw,size(varw,1),1,size(varw,2))),1))).^2)) ) / (size(vary,1)*size(vary,2)); 
    iter = 20000; 
    EPS  = 10^(-3); 
    param.inner.eps         = EPS;
    opt_lower = optimGS_setting_lambda( param.inner );

    %folders
    folder_name1 = ".\synthesizeDataset";
    folder_name2 = ".\BiGLasso-master_lambda\BiGLasso-master\Results_synthesizeDataset";   
    folder_name3 = ".\BiGLasso-master_penalty_lambda\BiGLasso-master\Results_synthesizeDataset";
    folder_name4 = ".\Plots_synthesizeDataset";
    mkdir .\Plots_synthesizeDataset

    UU_obj_ = [];
    W_norm_ = [];
    sampl = 10; %samples %number of synthetic datasets same parameters
    for it=1:sampl
        UU_obj = [];
        W_norm = [];
        %load dataset
        file_name="synth_dataset_N"+num2str(N)+"_P"+num2str(P)+"_T"+num2str(T)+"_L"+num2str(L)+"_S"+num2str(S)+"_DIST"+ssynth.groups.distrib+"_NOISE"+num2str(ssynth.noise.param(2))+"_a"+num2str(ssynth.features.a)+"_"+num2str(it)+'.mat';
        file_name = fullfile(folder_name1,file_name); 
        load(file_name) 

        %from cell to matrix
        y.trn = cell2mat(y.trn); 
        y.val = cell2mat(y.val);
        y.tst = cell2mat(y.tst);
        X.trn = cat(3,X.trn{:}); 
        X.val = cat(3,X.val{:});
        X.tst = cat(3,X.tst{:});

        %original lambda
        file_name = "lambda_result_synth_dataset_N"+num2str(N)+"_P"+num2str(P)+"_T"+num2str(T)+"_L"+num2str(L)+"_S"+num2str(S)+"_DIST"+ssynth.groups.distrib+"_NOISE"+num2str(ssynth.noise.param(2))+"_a"+num2str(ssynth.features.a)+'_'+num2str(it)+'.mat';
        file_name = fullfile(folder_name2,file_name); 
        load(file_name) 
    
        param.inner.eps         = EPS;
        param.inner.saveIterates = 0;
        lambda = lambdaHat; 

        theta = thetastar; 
        [W,~,~] = optimGS_lower_lambda(y.trn,X.trn,theta,lambda,opt_lower,param.inner,iter); %sol LL
        UU_obj = [UU_obj , obj(y.val,X.val,W)]; %objective function UL
        W_norm = [W_norm, norm(W-wstar)];

        theta = thetaHat_;
        [W,~,~] = optimGS_lower_lambda(y.trn,X.trn,theta,lambda,opt_lower,param.inner,iter); %sol LL
        UU_obj = [UU_obj , obj(y.val,X.val,W)]; %objective function UL
        W_norm = [W_norm, norm(W-wstar)];
        

        theta = thetaHat; 
        [W,~,~] = optimGS_lower_lambda(y.trn,X.trn,theta,lambda,opt_lower,param.inner,iter); %sol LL
        UU_obj = [UU_obj , obj(y.val,X.val,W)]; %objective function UL
        W_norm = [W_norm, norm(W-wstar)];

        %penalty lambda
        file_name = "penalty_lambda_result_synth_dataset_N"+num2str(N)+"_P"+num2str(P)+"_T"+num2str(T)+"_L"+num2str(L)+"_S"+num2str(S)+"_DIST"+ssynth.groups.distrib+"_NOISE"+num2str(ssynth.noise.param(2))+"_a"+num2str(ssynth.features.a)+"_"+num2str(it)+'.mat';
        file_name = fullfile(folder_name3,file_name); 
        load(file_name); 
    
        param.inner.eps         = EPS;
        param.inner.saveIterates = 0;
        lambda = lambdaHat{it_cond}(end); 

        theta = thetastar; 
        [W,~,~] = optimGS_lower_lambda(y.trn,X.trn,theta,lambda,opt_lower,param.inner,iter); %sol LL
        UU_obj = [UU_obj , obj(y.val,X.val,W)]; %objective function UL
        W_norm = [W_norm, norm(W-wstar)];

        theta = thetaHat; 
        [W,~,~] = optimGS_lower_lambda(y.trn,X.trn,theta,lambda,opt_lower,param.inner,iter); %sol LL
        UU_obj = [UU_obj , obj(y.val,X.val,W)]; %objective function UL
        W_norm = [W_norm, norm(W-wstar)];

        UU_obj_ = [UU_obj_; UU_obj];
        W_norm_ = [W_norm_; W_norm];

    end

    Tab=table(UU_obj_);
    file_name = "obj_synth_dataset_N"+num2str(N)+"_P"+num2str(P)+"_T"+num2str(T)+"_L"+num2str(L)+"_S"+num2str(S)+"_DIST"+ssynth.groups.distrib+"_NOISE"+num2str(ssynth.noise.param(2))+"_a"+num2str(ssynth.features.a)+"_"+num2str(it)+".csv";
    file_name = fullfile(folder_name4,file_name); 
    writetable(Tab,file_name,'Delimiter',';'); %csv file

    Tab=table(W_norm_);
    file_name = "Wnorm_synth_dataset_N"+num2str(N)+"_P"+num2str(P)+"_T"+num2str(T)+"_L"+num2str(L)+"_S"+num2str(S)+"_DIST"+ssynth.groups.distrib+"_NOISE"+num2str(ssynth.noise.param(2))+"_a"+num2str(ssynth.features.a)+"_"+num2str(it)+".csv";
    file_name = fullfile(folder_name4,file_name); 
    writetable(Tab,file_name,'Delimiter',';'); %csv file


    