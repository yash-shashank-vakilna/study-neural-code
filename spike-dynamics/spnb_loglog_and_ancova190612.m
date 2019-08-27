regList = {'EC','DG','CA3','CA1'}; 
load SubRegSpikeBurstDyn.mat
% regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
regOrder = [1 2 4 3 ]; ax = [];
f1 = figure(1);
clf
clr = {'r','g','b','c'};
linS = {'-','--',':','-.'}; 
maxLim = [2, 2.1, 2.1, 2];  minLim = [0.9 0.9 1.1 0.9];
pAll = [];
probAncova = []; histQAncova=[]; regAncova = [];
for regI = 1:4
    lx = logspace(log10(5),3,120);
    h = histogram(allfolderRegion{regI}.spnb,'BinEdges',lx,'Visible','off');
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    %% Plot scatter plot
    hold on
    loghistQ = log10(histQ); nzI = prob > 0;
    p = scatter(histQ(nzI), prob(nzI),strcat('.',clr{regI}),'DisplayName',regList{regI});
    set(gca,'YScale','log','XScale','log')
    %% Plot linear regression 
    nzI =  loghistQ < maxLim(regI) & loghistQ > minLim(regI);                                 % Normalize and remove outliers
    loghistQ = log10(histQ); 
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    probAncova = [probAncova; logcount'];
    histQAncova = [histQAncova; loghistQ'];
    regAncova = [regAncova; repmat(categorical(regList(regI)),length(loghistQ),1)];
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    modlx = logspace(minLim(regI),minLim(regI)+2,500);
    ly = 10.^(coeff(2)*log10(modlx)+coeff(1));
    plot(modlx,ly,'--k','LineWidth',3)
    set(gca,'fontsize',16,'YMinorTick','on', 'YMinorGrid','on','XMinorTick','on', 'XMinorGrid','on')
    axis([-inf inf 1e-2 1])
    pAll = [pAll, p];
end

xlabel('Spikes per Burst','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)

% legend(pAll)
hold off
%%
load tunnSpikeBurstDyn.mat
regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
regOrder = [1 2 4 3 ]; ax = [];
f1 = figure(2);
clf
clr = {'r','g','b','c'};
linS = {'-','--',':','-.'}; 
maxLim = [2.1, 2.1, 2.1, 2.1];  minLim = [0.8 0.8 0.8 0.8];
pAll = [];
probAncova = []; histQAncova=[]; regAncova = [];
for regI = 1:4
    lx = logspace(log10(5),3,120);
    h = histogram(allfolderRegion{regI}.spnb,'BinEdges',lx,'Visible','off');
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    %% Plot scatter plot
    hold on
    loghistQ = log10(histQ); nzI = prob > 0;
    p = scatter(histQ(nzI), prob(nzI),strcat('.',clr{regI}),'DisplayName',regList{regI});
    set(gca,'YScale','log','XScale','log')
    %% Plot linear regression 
    nzI =  loghistQ < maxLim(regI) & loghistQ > minLim(regI);                                 % Normalize and remove outliers
    loghistQ = log10(histQ); 
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    probAncova = [probAncova; logcount'];
    histQAncova = [histQAncova; loghistQ'];
    regAncova = [regAncova; repmat(categorical(regList(regI)),length(loghistQ),1)];
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    modlx = logspace(minLim(regI),minLim(regI)+2,500);
    ly = 10.^(coeff(2)*log10(modlx)+coeff(1));
    plot(modlx,ly,'--k','LineWidth',3)
    set(gca,'fontsize',16,'YMinorTick','on', 'YMinorGrid','on','XMinorTick','on', 'XMinorGrid','on')
%     axis([-inf inf -inf 1.1])
    pAll = [pAll, p];
end

xlabel('Spikes per Burst','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)

legend(pAll)
hold off
%% Tunnels 
% saveas(gcf,'ISI_histogram.png')
%% ANCOVA
% % 
%  [h,atab,ctab,stats] = aoctool(histQAncova,probAncova,regAncova);
%  multcompare(stats,0.05,'on','','s')
% %  