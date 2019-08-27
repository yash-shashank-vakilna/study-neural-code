% regList = {'EC','DG','CA3','CA1'}; 
regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
xEdge = logspace(0,3,100); xCenter = conv(xEdge, [0.5 0.5], 'valid');
%%
f1 = figure(1);
clf
clr = {'r','g','b','k'};
linS = {'-','--',':','-.'}; 
mark = {'o','+','x','*'};

hold on 
pAll=[];
for regI = 1:4
    col=1; count = [];
    for meai = 1:7
        if isempty(allfolderRegion{regI}.BD{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.BD{meai}, xEdge,'Visible'...
            ,'off');
        count(col,:) = h.BinCounts; col = col + 1;
    end
    
    meanC = mean(count,1); stdC = stdErr(count,1);
%     p=errorbar(xCenter, meanC, stdC,'Color',clr{regI},'Marker',mark{regI},'DisplayName',regList{regI});
    p=errorbar(xCenter, meanC, stdC, strcat(linS{regI}, mark{regI}, clr{regI}));
    pAll = [pAll p]; 
end
legend(pAll, regList)
title('Burst duration','FontSize',16)
xlabel('ms','Color','k','FontSize',16)
ylabel('Count','Color','k','FontSize',16)
set(gca,'fontsize',16,'XScale','log','XLim',[1 1e3])
% saveas(gcf,'ibsr_allin1hist.png')
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
        meaModBD( meaC, regI) = xCenter(maxI(end)); meaC = meaC + 1;
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
saveas(gca,'modBD-bar.png')