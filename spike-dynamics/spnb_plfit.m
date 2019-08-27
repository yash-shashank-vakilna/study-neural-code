cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\spike-dynamics

%% Subregion ISI
load SubRegSpikeBurstDyn.mat
regList = {'EC','DG','CA3','CA1'}; 
clr = {'r','g','b','c'};
linS = {'-','--',':','-.'}; 
% mark = {'o','+','x','*'};
mark = {'.','.','.','.'};
figure(1), clf
hold on
pAll = [];
for regI = 1:4
    [alpha(regI), xmin(regI)] = plfit(allfolderRegion{regI}.spnb);
    
    %% Plot scatter plot
    p = plplot(allfolderRegion{regI}.spnb, xmin(regI), alpha(regI), strcat(clr{regI}, mark{regI}), regList{regI});
    hold on
    pAll = [pAll p];
end
% title('Spike per ','FontSize',16)
xlabel('Spikes per Burst','Color','k','FontSize',16)
set(gca,'XScale','log','yscale','log')
legend(pAll)
hold off
axis square
%% Tunnel ISI
load tunnSpikeBurstDyn.mat
regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
f1 = figure(2);
clf
clr = {'r','g','b','c'};
linS = {'-','--',':','-.'}; 
% mark = {'o','+','x','*'};
figure(1)
hold on
pAll = [];
for regI = 1:4
    [alpha(regI), xmin(regI)] = plfit(allfolderRegion{regI}.spnb);
    
    %% Plot scatter plot
    p = plplot(allfolderRegion{regI}.spnb, xmin(regI), alpha(regI), strcat(clr{regI}, mark{regI}), regList{regI});
    hold on
    pAll = [pAll p];
end

xlabel('Spikes per Burst','Color','k','FontSize',16)
set(gca,'XScale','log','yscale','log')
legend(pAll)
hold off
axis square