cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\spike-dynamics
% burst_and_spike_dynamics_histogram_calculate
load SubRegSpikeBurstDyn.mat

%% ISI log-log plot and best fit line
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
isiLim =    [0.05, 0.1, 0.2, 0.2];

clf
for meaI = 1:4
    tax = subplot(2,2, regOrder(meaI));
    h = histogram(allfolderRegion{meaI}.ISI);
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    %% Plot scatter plot
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < 1;
    scatter(histQ(nzI), prob(nzI),'.k')
    set(gca,'YScale','log','XScale','log')
    hold on
    %% Plot linear regression 
    
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < isiLim(meaI);
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    scatter(histQ(nzI), prob(nzI),'.k')
    set(gca,'YScale','log','XScale','log')
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    lx = logspace(-2,1); ly = 10.^(coeff(2)*log10(lx)+coeff(1));
    plot(lx,ly)
    
%     text(1,1,"Slope = "+round(coeff(2),2)+", Intercept = "+round(coeff(1),2))
%     text(1,0.5,"R^2 = "+round(mdl.Rsquared.Ordinary,2))
%     text(1,0.25,"P-value < 0.0001")
    title(regList{meaI})
    set(gca,'fontsize',16)
    ax = [ax tax];
    hold off
end
linkaxes(ax, 'xy')
title('Interspike Interval','FontSize',16)
xlabel('ISI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
