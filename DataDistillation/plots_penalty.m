function plots_penalty(dataset,budget)

if dataset == "music"
    T = readtable("Datasets\yearpredictionmsd\Results\analysis_penalty_budget"+budget+".csv");
    T = T{:,:};
    
    plot(T(:,1));
    title("Objective function UL"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_of_budget"+budget+"_penalty.png")
    
    plot(T(:,2));
    title("Objective function UL with penalty"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_ofpen_budget"+budget+"_penalty.png")
    
    plot(T(:,3));
    title("Budget penalty"); 
    yline(T(:,6));
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_budget_budget"+budget+"_penalty.png")   
    
    plot(T(:,4));
    title("Objective function test set"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_oftest_budget"+budget+"_penalty.png")
    
    plot(T(:,5));
    title("Mean-Square-Error (RMSE)"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_RMSE_budget"+budget+"_penalty.png")

elseif dataset == "blog"
    T = readtable("Datasets\blogfeedback\Results\analysis_penalty_budget"+budget+".csv");
    T = T{:,:};
    
    plot(T(:,1));
    title("Objective function UL"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_of_budget"+budget+"_penalty.png")
    
    plot(T(:,2));
    title("Objective function UL with penalty"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_ofpen_budget"+budget+"_penalty.png")
    
    plot(T(:,3));
    title("Budget penalty"); 
    yline(T(:,6));
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_budget_budget"+budget+"_penalty.png")   
    
    plot(T(:,4));
    title("Objective function test set"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_oftest_budget"+budget+"_penalty.png")
    
    plot(T(:,5));
    title("Mean-Square-Error (RMSE)"); 
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_RMSE_budget"+budget+"_penalty.png")

end
