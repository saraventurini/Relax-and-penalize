%save synthetic datasets

%fix seed
rng(1)

clearvars;
close all;

%\\\\\ Synthesis parameters
N                           = 20;          %Number of samples
P                           = 100;           %Number of features
T                           = 500;          %Number of tasks
L                           = 10;          %Number of groups
S                           = 1;           %Number of non-zero groups per task
synth.groups.distrib        = 'rand';   %Group size ('equal' or 'rand' or 'inequal' )
synth.design.setting        = 'general';   
synth.design.renorm         = true;
synth.noise.distrib         = 'normal';       
synth.noise.param           = [0 .2];       %~Normal with mean 'param(1)' and var 'param(2)'
synth.features.a     = 0.3; 

%% SYNTHESIS 
folder_name = "synthesizeDataset";
sampl = 10; %samples %number of synthetic datasets same parameters

for i=1:sampl

    %create dataset
    [y,X,thetastar,wstar,Xwstar] = synthesizeDataset( N, P, T, L, S,synth);
    %save dataset 
    file_name="synth_dataset_N"+num2str(N)+"_P"+num2str(P)+"_T"+num2str(T)+"_L"+num2str(L)+"_S"+num2str(S)+"_DIST"+synth.groups.distrib+"_NOISE"+num2str(synth.noise.param(2))+"_a"+num2str(synth.features.a)+"_"+num2str(i)+'.mat';
    file_name = fullfile(folder_name,file_name); 
    save(file_name,'N','P','T','L','S','synth','y','X','thetastar','wstar','Xwstar')
    
    %plot oracle
    figure(101);clf;
    subplot(121);
    imagesc(thetastar);
    xlabel('Groups','Interpreter','latex','fontsize',2)
    ylabel('Features','Interpreter','latex','fontsize',2)
    title('Oracle $\theta^*$','Interpreter','latex','fontsize',2)
    set(gca,'fontsize',15,'clim',[0 1])
    colorbar;
    colormap(parula);
    c=subplot(122);
    wlim = max([abs(min(min(wstar))),abs(max(max(wstar)))]);
    imagesc(wstar);
    colorbar;
    colormap(parula);
    xlabel('Tasks','Interpreter','latex','fontsize',2)
    ylabel('Features','Interpreter','latex','fontsize',2)
    title('Oracle $w^*$','Interpreter','latex','fontsize',2)
    set(gca,'fontsize',15,'CLim',[-wlim wlim])

end

