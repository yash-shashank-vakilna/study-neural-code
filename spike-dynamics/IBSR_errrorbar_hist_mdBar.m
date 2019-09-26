xEdge = linspace(0,1e3,100); xCenter = conv(xEdge, [0.5 0.5], 'valid');
regList = {'EC','DG','CA3','CA1'}; 
% regList = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'}; 
%%
figure(1)
clf
clr = {'r','g','b','k'};
linS = {'-','--',':','-.'}; 
mark = {'o','+','x','*'};
figno = [1 2 4 3];
hold on 
pAll=[];
for regI = [1, 3]
    col=1; count = [];
%     pl(regI)=subplot(2,2,figno(regI));
    for meai = 1:7
        if isempty(allfolderRegion{regI}.IBSR{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.IBSR{meai}, xEdge,'Visible'...
            ,'off');
        count(col,:) = h.BinCounts; col = col + 1;
    end
    
    meanC = mean(count,1); stdC = stdErr(count,1);
%     p=errorbar(xCenter, meanC, stdC,'Color',clr{regI},'Marker',mark{regI},'DisplayName',regList{regI});
%     p=errorbar(xCenter, meanC, stdC, strcat(linS{regI}, mark{regI}, clr{regI}),'.k');
    p=errorbar(xCenter, meanC, stdC,'-k', 'Color',clr{regI});
    set(gca,'fontsize',12,'XScale','log','XLim',[10 1e3])
    pAll = [pAll p];
    title(regList{regI})
end
% linkaxes(pl,'xy')
% legend(pAll, regList)
xlabel('Intraburst spike rate (Hz)')
ylabel('Count')

% saveas(gcf, 'ibsr_singleC.png')
%% Using mode to compare
figure(2)
clf
meaModIBSR = zeros(5, 4);
for regI = 1:4
    col=1; count = [];
    meaC = 1;
    for meai = 1:7
        if isempty(allfolderRegion{regI}.IBSR{meai})
            continue
        end
        h = histogram(allfolderRegion{regI}.IBSR{meai}, xEdge,'Visible'...
            ,'off');
        count = h.BinCounts;  maxI=find(count == max(count));
        meaModIBSR( meaC, regI) = xCenter(maxI(1)); meaC = meaC + 1;
    end
    
end

mods = mean( meaModIBSR,1); errorMod = stdErr(meaModIBSR,1);
bar(mods);hold on
errorbar(1:4 , mods, errorMod,'.k');
xticklabels(regList)
set(gca,'FontSize',16)
ylabel('Mode interaburst Spike Rate (Hz)'); xlabel('subregion')
xticklabels(regList)
% saveas(gca,'modIBSR-bar.png')
%  anova1(meaModIBSR)