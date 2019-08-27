cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\spike-dynamics

%% Subregion ISI
% load SubRegSpikeBurstDyn.mat
regList = {'EC','DG','CA3','CA1'}; 
f1 = figure(1);
clf
clr = {'r','g','b','c'};
linS = {'-','--',':','-.'}; 
% mark = {'o','+','x','*'};
mark = {'.','.','.','.'};
figure(1)
hold on
pAll = [];
for regI = 1:4
    data=randsample( allfolderRegion{regI}.ISI,round(0.1*length(allfolderRegion{regI}.ISI)));
    fitData =data;
%     fitData = data(data<1);
    xmin = quantile(data, 0.50);
%     rang = [1.001:0.001:5.001]; 
%     [alpha(regI), xmin(regI)] = plfit(fitData, 'xmin', xmin);
    [alpha(regI), xmin(regI)] = plfit(fitData, 'xmin',0.005);
%     [alpha(regI), xmin(regI)] = plfit(fitData);
    %% Plot scatter plot
    p = plplot(fitData, xmin(regI), alpha(regI), strcat(clr{regI}, mark{regI}), regList{regI});
    hold on
    pAll = [pAll p];
end
title('Interspike Interval','FontSize',16)
xlabel('ISI (s)','Color','k','FontSize',16)
set(gca,'XScale','log','yscale','log','xlim',[-inf 1],'YLim',[1e-2 inf])
saveas(gcf,'subregion-figs/isi.fig')
legend(pAll)
hold off
axis square
% %% Tunnel ISI
% load tunnSpikeBurstDyn.mat
% regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
% figure(2)
% clf
% clr = {'r','g','b','k'};
% linS = {'-','--',':','-.'}; 
% mark = {'.','.','.','.'};
% % mark = {'o','+','x','*'};
% hold on
% pAll = [];
% for regI = 1:4
%     data=randsample( allfolderRegion{regI}.ISI,round(0.1*length(allfolderRegion{regI}.ISI)));
%     fitData =data;
%     [alpha(regI), xmin(regI)] = plfit(data);
%     
%     %% Plot scatter plot
%     p = plplot(data, xmin(regI), alpha(regI), strcat(clr{regI}, mark{regI}), regList{regI});
%     hold on
%     pAll = [pAll p];
% end
% title('Interspike Interval','FontSize',16)
% xlabel('ISI (s)','Color','k','FontSize',16)
% set(gca,'XScale','log','yscale','log')
% legend(pAll)
% hold off
% axis square
