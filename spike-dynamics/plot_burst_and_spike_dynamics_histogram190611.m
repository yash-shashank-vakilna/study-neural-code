cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\spike-dynamics
% burst_and_spike_dynamics_histogram_calculate
load spikDynamicsResultsSriChecked.mat
%% Spike rate barplot

regList = {'EC','DG','CA3','CA1'}; 
mean_SR = []; SD_SR = [];
for meaI = 1:4
    mean_SR = [mean_SR mean(allfolderRegion{meaI}.SR)];
    SD_SR = [SD_SR stdErr(allfolderRegion{meaI}.SR)];
end
figure(1)
bar(mean_SR)
hold on
errorbar(1:4,mean_SR, SD_SR,'.k')
ylabel('Spike rate (hz)')
xticks(1:4), xticklabels(regList)
title('Channel spike rate')
set(gca,'FontSize',16)
hold off
% Anova
anova_table = []; anova_label = [];
for meaI = 1:4
    anova_table = [anova_table, allfolderRegion{meaI}.SR'];
    anova_label = [anova_label, repmat(regList(meaI),1,length(allfolderRegion{meaI}.SR))]; 
end
[p,tbl,stats] = anova1(anova_table, anova_label);  
 [c,m,h,gnames] = multcompare(stats); 

%% ISI log-log plot and best fit line
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
isiLim =    [0.05, 0.1, 0.2, 0.2];
f1 = figure;
bkclr = get(f1,'Color') ; % The figure's background color
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
    
    text(1,1,"Slope = "+round(coeff(2),2)+", Intercept = "+round(coeff(1),2))
    text(1,0.5,"R^2 = "+round(mdl.Rsquared.Ordinary,2))
    text(1,0.25,"P-value < 0.0001")
    title(regList{meaI})
    set(gca,'fontsize',16)
    ax = [ax tax];
    hold off
end
linkaxes(ax, 'xy')

bkax = axes; % this creates a figure-filling new axes
set(bkax,'Xcolor',bkclr,'Ycolor',bkclr,'box','off','Color','none') % make it 'disappear'
title('Interspike Interval','FontSize',16)
xlabel('ISI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
uistack(bkax,'bottom'); % this moves it to the background.
saveas(gcf,'ISI_histogram.png')

%% No. spike per burst% log-log plot and best fit line

regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
Lim =    [3, 2.1, 2.1, 2.1];
f1 = figure;
bkclr = get(f1,'Color') ; % The figure's background color
clf
for meaI = 1:4
    tax = subplot(2,2, regOrder(meaI));
    h = histogram(allfolderRegion{meaI}.spnb);
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    %% Plot scatter plot
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < 3;
    scatter(histQ(nzI), prob(nzI),'.k')
    set(gca,'YScale','log','XScale','log')
    hold on
    %% Plot linear regression 
    
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < Lim(meaI);
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    scatter(histQ(nzI), prob(nzI),'.k')
    set(gca,'YScale','log','XScale','log')
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    lx = logspace(0,3); ly = 10.^(coeff(2)*log10(lx)+coeff(1));
    plot(lx,ly)
    
    text(10^2,1,"Slope = "+round(coeff(2),2)+", Intercept = "+round(coeff(1),2))
    text(10^2,0.5,"R^2 = "+round(mdl.Rsquared.Ordinary,2))
    text(10^2,0.25,"P-value < 0.0001")
    title(regList{meaI})
    set(gca,'fontsize',16)
    ax = [ax tax];
    hold off
end
linkaxes(ax, 'xy')

bkax = axes; % this creates a figure-filling new axes
set(bkax,'Xcolor',bkclr,'Ycolor',bkclr,'box','off','Color','none') % make it 'disappear'
title('','FontSize',16)
xlabel('Spikes per Burst','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
uistack(bkax,'bottom'); % this moves it to the background.
saveas(gcf,'spikesPerBurst.png')
%% Intra-burst spike rate %% log-log plot and best fit line
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
f1 = figure(1);
bkclr = get(f1,'Color') ; % The figure's background color
xEdge = linspace(0,1e3,100); xCenter = conv(xEdge, [0.5 0.5], 'valid');
clf
for regI = 1:4
    col=1; count = [];
    for meai = 1:7
        if isempty(allfolderRegion{regI}.IBSR{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.IBSR{meai}, xEdge,'Visible'...
            ,'off');
        count(col,:) = h.BinCounts; col = col + 1;
    end
    sub_ax = subplot(2,2, regOrder(regI));
    meanC = mean(count,1); stdC = stdErr(count,1);
    hold on
    errorbar(xCenter, meanC, stdC,'k')
    title(regList{regI})
    set(gca,'fontsize',16,'XScale','log','XLim',[10 1e3])
    ax = [ax sub_ax];
end
linkaxes(ax, 'xy')
saveas(gcf,'IBSR.png')
bkax = axes; % this creates a figure-filling new axes
set(bkax,'Xcolor',bkclr,'Ycolor',bkclr,'box','off','Color','none') % make it 'disappear'
title('Intraburst spike rate','FontSize',16)
xlabel('Hz','Color','k','FontSize',16)
ylabel('Count','Color','k','FontSize',16)
uistack(bkax,'bottom'); % this moves it to the background.
saveas(gcf,'IBSR.png')
%% Inter burst interval% log-log plot and best fit line
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
Lim = [1.2 2 1.5 1.2];
f1 = figure;
bkclr = get(f1,'Color') ; % The figure's background color
clf
for meaI = 1:4
    tax = subplot(2,2, regOrder(meaI));
    h = histogram(allfolderRegion{meaI}.IBI);
    count = (h.BinCounts); prob = fliplr(cumsum(fliplr(count)))./sum(count);
    histQ = (conv(h.BinEdges, [0.5 0.5], 'valid'));
    %% Plot scatter plot
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < 2;
    scatter(histQ(nzI), prob(nzI),'.k')
    set(gca,'YScale','log','XScale','log')
    hold on
    %% Plot linear regression 
    
    loghistQ = log10(histQ); nzI = prob > 0 & loghistQ < Lim(meaI);
    loghistQ = loghistQ (nzI); logcount = log10(prob(nzI)); 
    scatter(histQ(nzI), prob(nzI),'.k')
    set(gca,'YScale','log','XScale','log')
    % fitting 
    mdl = fitlm(loghistQ, logcount);
    coeff = mdl.Coefficients.Estimate;
    lx = logspace(-1,2); ly = 10.^(coeff(2)*log10(lx)+coeff(1));
    plot(lx,ly)
    
    text(10^1,1,"Slope = "+round(coeff(2),2)+", Intercept = "+round(coeff(1),2))
    text(10^1,0.5,"R^2 = "+round(mdl.Rsquared.Ordinary,2))
    text(10^1,0.25,"P-value < 0.0001")
    title(regList{meaI})
    set(gca,'fontsize',16)
    ax = [ax tax];
    hold off
end
linkaxes(ax, 'xy')

bkax = axes; % this creates a figure-filling new axes
set(bkax,'Xcolor',bkclr,'Ycolor',bkclr,'box','off','Color','none') % make it 'disappear'
title('Interburst Interval','FontSize',16)
xlabel('IBI (s)','Color','k','FontSize',16)
ylabel('Pr(X \geq x)','Color','k','FontSize',16)
uistack(bkax,'bottom'); % this moves it to the background.
saveas(gcf,'ibi.png')

%% Intra-burst spike rate
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
figure(1)
clf
for meaI = 1:4
    sub_ax = subplot(2,2, regOrder(meaI));
    h = histogram(allfolderRegion{meaI}.IBSR,2000, 'EdgeColor','none');
    plot( conv(h.BinEdges, [0.5 0.5], 'valid'),h.BinCounts)
%     xlabel('Burst duration (ms)'); ylabel('Count')
    title(regList{meaI})
    set(gca,'fontsize',16,'XScale','log','xlim',[0 1e3],'Ylim',[0 260])
%     set(gca,'fontsize',16)
    ax = [ax sub_ax];
end
linkaxes(ax, 'xy')
%% IBSR all in single axes
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
f1 = figure(1);
bkclr = get(f1,'Color') ; % The figure's background color
xEdge = linspace(0,1,500); xCenter = conv(xEdge, [0.5 0.5], 'valid');
figure(1)
clf
clr = {'r','g','b','k'};
linS = {'-','--',':','-.'}; 
mark = {'o','+','x','*'};
hold on 
pAll=[];
for regI = 1:4
    col=1; count = [];
    for meai = 1:7
        if isempty(allfolderRegion{regI}.IBSR{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.IBSR{meai}, xEdge,'Visible'...
            ,'off');
        count(col,:) = h.BinCounts; col = col + 1;
    end
    
    meanC = mean(count,1); stdC = stdErr(count,1);
    p=errorbar(xCenter, meanC, stdC,'Color',clr{regI},'Marker',mark{regI},'DisplayName',regList{regI});
    pAll = [pAll p]; 
end
legend(pAll)
xlabel('Intraburst spike rate (Hz)')
ylabel('Count')
set(gca,'fontsize',16,'XScale','log','XLim',[10 1e3])
saveas(gcf, 'ibsr_singleC.png')

%% Burst duration 
%%histogram
regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
f1 = figure(1);
bkclr = get(f1,'Color') ; % The figure's background color
xEdge = linspace(0,1,500); xCenter = conv(xEdge, [0.5 0.5], 'valid').*1e3;
clf
for regI = 1:4
    col=1; count = [];
    for meai = 1:7
        if isempty(allfolderRegion{regI}.BD{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.BD{meai}, xEdge,'Visible','off','Normalization','probability');
        count(col,:) = h.BinCounts; col = col + 1;
    end
    sub_ax = subplot(2,2, regOrder(regI));
    meanC = mean(count,1); stdC = stdErr(count,1);
    hold on
    errorbar(xCenter, meanC, stdC,'k')
    title(regList{regI})
    set(gca,'fontsize',16,'XScale','log','xlim',[1 10^3])
    ax = [ax sub_ax];
end
linkaxes(ax, 'xy')

bkax = axes; % this creates a figure-filling new axes
set(bkax,'Xcolor',bkclr,'Ycolor',bkclr,'box','off','Color','none') % make it 'disappear'
title('Burst duration','FontSize',16)
xlabel('ms','Color','k','FontSize',16)
ylabel('Count','Color','k','FontSize',16)
uistack(bkax,'bottom'); % this moves it to the background.
saveas(gcf,'BD.png')

% %% No. spike per burst %%histogram
% regList = {'EC','DG','CA3','CA1'}; regOrder = [1 2 4 3 ]; ax = [];
% figure(1)
% clf
% for meaI = 1:4
%     sub_ax = subplot(2,2, regOrder(meaI));
%     histogram(allfolderRegion{meaI}.spnb,1000);
%     xlabel('Spikes per Burst'); ylabel('Count')
%     title(regList{meaI})
%     set(gca,'fontsize',16,'yscale','log','xlim',[0 300])
%     ax = [ax sub_ax];
% end
% linkaxes(ax, 'xy')