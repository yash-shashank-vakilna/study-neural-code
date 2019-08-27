cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\spike-dynamics
%% Subregion
load SubRegSpikeBurstDyn.mat
regList = {'EC','DG','CA3','CA1'}; 
regOrder = [1 2 4 3 ]; ax = [];
maxLim =    [0.02, 0.1, -0.8, 0];  minLim = [-1.4 -1.5 -1.4 -1.4 ];
f1 = figure(1);
clf
clr = {'r','g','b','c'};
probAncova = []; histQAncova=[]; regAncova = []; pAll=[];
for regI = 1:4
    lx = logspace(-2,1,500);
    h = histogram(allfolderRegion{regI}.ISI,'Visible','off','BinEdges',lx);
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    
    %% Plot scatter plot
    hold on
    loghistQ = log10(histQ); nzI = loghistQ < 1;
    p = scatter(histQ(nzI), prob(nzI),strcat('.',clr{regI}),'DisplayName',regList{regI});
    set(gca,'YScale','log','XScale','log')
    %% Plot linear regression 
    nzI =  loghistQ < maxLim(regI) & loghistQ > minLim(regI);                                 % Normalize and remove outliers
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
    set(gca,'fontsize',16,'YMinorTick','on', 'YMinorGrid','on','XMinorTick','on', 'XMinorGrid','on', 'xlim',[-inf 2]);
    pAll = [pAll p];
end
title('Interspike Interval','FontSize',16)
xlabel('ISI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
axis square
legend(pAll)
hold off
%% Tunnels

load tunnSpikeBurstDyn.mat
regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
regOrder = [1 2 4 3 ]; ax = [];
maxLim =    [0.05, 0.1, 0.2, 0.2];  minLim = -1.3;
f1 = figure(1);
clf
clr = {'r','g','b','c'};
probAncova = []; histQAncova=[]; regAncova = []; pAll=[];
for regI = 1:4
    lx = logspace(-2,1,500);
    h = histogram(allfolderRegion{regI}.ISI,'Visible','off','BinEdges',lx);
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    
    %% Plot scatter plot
    hold on
    loghistQ = log10(histQ); nzI = loghistQ < 1;
    p = scatter(histQ(nzI), prob(nzI),strcat('.',clr{regI}),'DisplayName',regList{regI});
    set(gca,'YScale','log','XScale','log')
    %% Plot linear regression 
%     loghistQ = log10(prob);
%     [alpha, xmin, L] = plfit(prob);
    nzI =  loghistQ < maxLim(regI) & loghistQ > -1.3;                                 % Normalize and remove outliers
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    probAncova = [probAncova; logcount'];
    histQAncova = [histQAncova; loghistQ'];
    regAncova = [regAncova; repmat(categorical(regList(regI)),length(loghistQ),1)];
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    ly = 10.^(coeff(2)*log10(modlx)+coeff(1));
    modlx = logspace(-1.3,1.3,500);
    plot(modlx,ly,'--k','LineWidth',3)
    set(gca,'fontsize',16, 'xlim',[-inf 1],'YMinorTick','on', 'YMinorGrid','on','XMinorTick','on', 'XMinorGrid','on')
    pAll = [pAll p];
end
title('Interspike Interval','FontSize',16)
xlabel('ISI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
legend(pAll)
hold off
axis square
% saveas(gcf, '.\tunnel-figs\ISI-hist.png')
%%

% saveas(gcf,'ISI_histogram.png')
% %% ANCOVA
% 
%  [h,atab,ctab,stats] = aoctool(histQAncova,probAncova,regAncova);
%  multcompare(stats,0.05,'on','','s')
%  