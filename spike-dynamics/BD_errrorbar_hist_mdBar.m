%% Burst duration 
%%histogram
% regList = {'EC','DG','CA3','CA1'}; 
regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
regOrder = [1 2 4 3 ]; ax = [];
f1 = figure(1);
bkclr = get(f1,'Color') ; % The figure's background color
xEdge = linspace(0,1,500); xCenter = conv(xEdge, [0.5 0.5], 'valid').*1e3;
clr = {'r','g','b','r'};
clf
for regI = [3]
    
    col=1; count = [];
    for meai = 1:7
        if isempty(allfolderRegion{regI}.BD{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.BD{meai}, xEdge,'Visible','off','Normalization','probability');
        count(col,:) = h.BinCounts; col = col + 1;
    end
%     sub_ax = subplot(2,2, regOrder(regI));
    meanC = mean(count,1); stdC = stdErr(count,1);
    hold on
    errorbar(xCenter, meanC, stdC,'-k');
    title(regList{regI})
    set(gca,'fontsize',12,'XScale','log','xlim',[1 10^3])
%     ax = [ax sub_ax];
    hold on
end
% linkaxes(ax, 'xy')
xlabel 'Mode Burst Buration (ms)'
ylabel Count

%% Using mode to compare
figure(2), clf
meaModBD = zeros(5, 4);
for regI = 1:4
    col=1; count = [];
    meaC = 1;
    for meai = 1:7
        if isempty(allfolderRegion{regI}.BD{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.BD{meai}, xEdge,'Visible'...
            ,'off');
        count = h.BinCounts;  maxI=find(count == max(count));
        meaModBD( meaC, regI) = xCenter(maxI(1)); meaC = meaC + 1;
    end
    
end

mods = mean( meaModBD,1); errorMod = stdErr(meaModBD);
bar(mods);hold on
errorbar(1:4 , mods, errorMod,'.k');
xticklabels(regList)
set(gca,'FontSize',16)
title('Burst duration','FontSize',16)
xlabel('Subregion','Color','k','FontSize',16)
ylabel('Mode Burst Duration (ms)','Color','k','FontSize',16)
xticklabels(regList)
hold off
% anova1(meaModBD)