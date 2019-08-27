regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
% regList = {'EC','DG','CA3','CA1'}; 
regOrder = [1 2 4 3 ]; ax = [];
Lim =    [0.05, 0.1, 0.2, 0.2];
f1 = figure(1);
clf
clr = {'r','g','b','k'};
linS = {'-','--',':','-.'}; 
mark = {'o','+','x','*'};
probAncova = []; histQAncova=[]; regAncova = [];
pAll = [];
for regI = 1:4
    h = histogram(allfolderRegion{regI}.ISI,'Visible','off');
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    
    %% Plot scatter plot
    hold on
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < 1;
    p = scatter(histQ(nzI), prob(nzI),strcat(mark{regI},clr{regI}),'DisplayName',regList{regI});
    set(gca,'YScale','log','XScale','log')
    %% Plot linear regression 
    
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < Lim(regI);
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    probAncova = [probAncova; logcount'];
    histQAncova = [histQAncova; loghistQ'];
    regAncova = [regAncova; repmat(categorical(regList(regI)),length(loghistQ),1)];
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    lx = logspace(-2,1); ly = 10.^(coeff(2)*log10(lx)+coeff(1));
    plot(lx,ly,clr{regI})
    set(gca,'fontsize',16)
    pAll = [pAll p];
end
title('Interspike Interval','FontSize',16)
xlabel('ISI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
legend(pAll)
hold off
saveas(gcf,'ISI_allin1hist.png')
%% ANCOVA

 [h,atab,ctab,stats] = aoctool(histQAncova,probAncova,regAncova);
 multcompare(stats,0.05,'on','','s')
 