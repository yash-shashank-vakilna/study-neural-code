% Using allregionresult cell array it populates to_plot cell array
% Concatenates allregionresults and seggregate regionswise
to_plot = cell(1,4);
burstI = 2; %burstI = 1 & 2 for burst & non-burst
mtitArra = {'Burst','Non-burst'};
for regi = 1:4
    for fi = [ 3 4 5 6 7]
%         to_plot_3cyc{regi} = [to_plot_3cyc{regi}; cell2mat(allregionresults{fi}{regi}(:,burstI))];
        to_plot{regi} = [to_plot{regi}; cell2mat(tunnelSetSeparatedResult{fi}{regi}(:,burstI))];
    end
end
%% Phase histogram
figno = [1 2 4 3];
% tit = ["EC","DG","CA3","CA1"];
tit = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
figure(burstI), clf
for regi=1:4
    
    subplot(2,2,figno(regi));
    p=polarhistogram((to_plot{regi}),40);
    max_r = p.Parent.RLim(2);
    binCounts = p.BinCounts;
    binCenter = conv(p.BinEdges, [0.5 0.5], 'valid');
    binMode = binCenter( binCounts == max(binCounts));
    binMode = binMode(1);
%     mean_ang = circ_mean(to_plot_3cyc{regi});
    hold on
    polarplot([binMode binMode], [0 max_r], 'r', 'LineWidth',2);
    hold off
    title(tit(regi))
    set(gca,'FontSize',16)
    
end


%% circ_anova 
for regI = 1:4
    [pval, ~] = circ_rtest(to_plot{regI})
end