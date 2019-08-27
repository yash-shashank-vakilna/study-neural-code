regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
Lim = [1.2 2 1.5 1.2];
f1 = figure(1);
clf
clr = {'r','g','b','k'};
linS = {'-','--',':','-.'}; 
mark = {'o','+','x','*'};
pAll = [];
probAncova = []; histQAncova=[]; regAncova = [];
for regI = 1:4
    h = histogram(allfolderRegion{regI}.IBI,'Visible','off');
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
    lx = logspace(-1,2); ly = 10.^(coeff(2)*log10(lx)+coeff(1));
    plot(lx,ly,clr{regI})
    set(gca,'fontsize',16,'YLim',[-inf 1],'XLim',[-inf 12])
    pAll = [pAll, p];
end
title('Interburst Interval','FontSize',16)
xlabel('IBI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
legend(pAll)
hold off
saveas(gcf,'IBI_allin1hist.png')
%% ANCOVA
% 
 [h,atab,ctab,stats] = aoctool(histQAncova,probAncova,regAncova);
 multcompare(stats,0.05,'on','','s')
%  