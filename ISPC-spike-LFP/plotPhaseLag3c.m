burstPhase = formatMEAwise2RegionWise(tunnelResultRegion,1);
nonburstPhase = formatMEAwise2RegionWise(tunnelResultRegion,2);
%% Phase histogram
figno = [1 2 4 3];
% tit = ["EC","DG","CA3","CA1"];
tit = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
figure(1)
for regi=1:4
    
    subplot(2,2,figno(regi));
    p=polarhistogram((burstPhase{regi}),40);
    max_r = p.Parent.RLim(2);
    mean_ang = circ_mean(burstPhase{regi});
    hold on
    polarplot([mean_ang mean_ang], [0 max_r], 'r', 'LineWidth',2);
    hold off
    title(tit(regi))
    set(gca,'FontSize',16)
%     rlim([0 25])
end

figure(2)
for regi=1:4
    
    subplot(2,2,figno(regi));
    p=polarhistogram((nonburstPhase{regi}),40);
    max_r = p.Parent.RLim(2);
    mean_ang = circ_mean(nonburstPhase{regi});
    hold on
    polarplot([mean_ang mean_ang], [0 max_r], 'r', 'LineWidth',2);
    hold off
    title(tit(regi))
    set(gca,'FontSize',16)
%     rlim([0 25])
end
%% circ_anova 

% [pval, table] = circ_wwtest(to_plot_3cyc{1}', to_plot_3cyc{2}');