% Using allregionresult cell array it populates to_plot cell array
% Concatenates allregionresults and seggregate regionswise
load ./data/burst-v-non-burst/phase_theta_allregionresult_burst_Seg.mat
to_plot = cell(1,4);
burstI = 2; %burstI = 1 & 2 for burst & non-burst
mtitArra = {'Burst','Non-burst'};
for regi = 1:4
    for fi = [ 3 4 5 6 7]
%         to_plot_3cyc{regi} = [to_plot_3cyc{regi}; cell2mat(allregionresults{fi}{regi}(:,burstI))];
        to_plot{regi} = [to_plot{regi}; cell2mat(allregionresults{fi}{regi}(:,burstI))];
    end
end
%% Phase histogram
figno = [1 2 4 3];
tit = ["EC","DG","CA3","CA1"];
% tit = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
figure(burstI), clf
for regi=1:4
    
    subplot(1,4,(regi));
    p=polarhistogram((to_plot{regi}),40,'visible','off');
    max_r = p.Parent.RLim(2);
    binCounts = p.BinCounts;
    binCenter = conv(p.BinEdges, [0.5 0.5], 'valid');
    binprob = binCounts./sum(binCounts);
    polarplot( [binCenter binCenter(1)], [binprob binprob(1)],'linewidth',2)
%     binMode = binCenter( binCounts == max(binCounts));
%     binMode = binMode(1);
    hold on
%     polarplot([binMode binMode], [0 max_r], 'r', 'LineWidth',2);
    hold off
    title(tit(regi))
    set(gca,'FontSize',16)
    %
    pval = circ_rtest((binCenter),binCounts, unique(diff(binCenter)));
%     shannon_entropy = -binCounts*log2(binCounts)';
%     text(0.1,.1,"entropy : " + shannon_entropy,'Color','red')
      text(0,0,"pval : " + pval,'Color','red')
end
%% 
