function plots(dataset,budget)

if dataset == "music"

    T = readtable("Datasets\yearpredictionmsd\Results\analysis_budget"+budget+".csv");
    T = T{:,:};
    
    plot(T(:,1));
    hold on;
    plot(T(:,2));
    title("Objective function UL"); 
    legend('before rounding','after rounding');
    legend('Location','eastoutside');
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_of_budget"+budget+".png")
    
    plot(T(:,3));
    title("Budget"); 
    yline(T(:,8));
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_budget_budget"+budget+".png")   

    plot(T(:,4));
    hold on;
    plot(T(:,5));
    title("Objective function test set"); 
    legend('without rounded weights','with rounded weights');
    legend('Location','eastoutside');
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_oftest_budget"+budget+".png") 
    
    plot(T(:,6));
    hold on;
    plot(T(:,7));
    title("Mean-Square-Error (RMSE)"); 
    legend('without rounded weights','with rounded weights');
    legend('Location','eastoutside');
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\yearpredictionmsd\Plots\plot_RMSE_budget"+budget+".png")

elseif dataset == "blog"
    T = readtable("Datasets\blogfeedback\Results\analysis_budget"+budget+".csv");
    T = T{:,:};
    
    plot(T(:,1));
    hold on;
    plot(T(:,2));
    title("Objective function UL"); 
    legend('before rounding','after rounding');
    legend('Location','eastoutside');
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_of_budget"+budget+".png")

    plot(T(:,3));
    hold on;
    title("Budget");
    yline(T(:,8));
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_budget_budget"+budget+".png") 
    
    plot(T(:,4));
    hold on;
    plot(T(:,5));
    title("Objective function test set"); 
    legend('without rounded weights','with rounded weights');
    legend('Location','eastoutside');
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_oftest_budget"+budget+".png")

    plot(T(:,6));
    hold on;
    plot(T(:,7));
    title("Mean-Square-Error (RMSE)"); 
    legend('without rounded weights','with rounded weights');
    legend('Location','eastoutside');
    hold off;
    set(gca,'fontsize',15,'clim',[0 1])
    saveas(gca,"Datasets\blogfeedback\Plots\plot_RMSE_budget"+budget+".png")

end

end

