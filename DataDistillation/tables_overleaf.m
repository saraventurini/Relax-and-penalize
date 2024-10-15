dataset_list = ["music","blog"];
budget_list = [10,20,30];

M = NaN(length(budget_list)*3*2,7);
i = 1;
for budget = budget_list

    T = readtable("Datasets\yearpredictionmsd\Results\analysis_budget"+budget+".csv");
    T = T{:,:};
    T = T(end,[10,1,2,3,5,7,9]);
    M(i,:)=T;
    i = i+1;

    T = readtable("Datasets\yearpredictionmsd\Results\analysis_penalty_budget"+budget+".csv");
    T = T{:,:};
    T = T(end,[7,1,3,4,5,6]);
    M(i,[1,3,4,5,6,7])=T;
    i = i+1;

end

for budget = budget_list

    T = readtable("Datasets\blogfeedback\Results\analysis_budget"+budget+".csv");
    T = T{:,:};
    T = T(end,[10,1,2,3,5,7,9]);
    M(i,:)=T;
    i = i+1;

    T = readtable("Datasets\blogfeedback\Results\analysis_penalty_budget"+budget+".csv");
    T = T{:,:};
    T = T(end,[7,1,3,4,5,6]);
    M(i,[1,3,4,5,6,7])=T;
    i = i+1;
    
end
writematrix(M,"Datasets\tables.csv",'Delimiter',';')

