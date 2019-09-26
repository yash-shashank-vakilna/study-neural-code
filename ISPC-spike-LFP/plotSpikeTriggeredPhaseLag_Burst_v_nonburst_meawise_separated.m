% Using allregionresult cell array it populates to_plot cell array
% Concatenates allregionresults and seggregate regionswise
load ./data/burst-v-non-burst/phase_theta_allregionresult_burst_Seg.mat
allregionresults = formatTunnelResultsbySeggregate (allregionresults);
mtitArra = {'Burst','Non-burst'};
to_plot = cell(4,7);
shannon_entropy = zeros(4,5,2);
uniform_distro = 1/40 * ones(1,40);
max_entropy = -uniform_distro*log2(uniform_distro)';
for burstI = 1:2 %burstI = 1 & 2 for burst & non-burst
    for regi = 1:4
        for fi = [ 3 4 5 6 7]
    %         to_plot_3cyc{regi} = [to_plot_3cyc{regi}; cell2mat(allregionresults{fi}{regi}(:,burstI))];
            to_plot{regi, fi} = [to_plot{regi, fi}; cell2mat(allregionresults{fi}{regi}(:,burstI))];
        end
    end
    %% Phase histogram
    figno = [1 2 4 3];
    tit = ["EC","DG","CA3","CA1"];
    % tit = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
    figure(burstI), clf
    
    for fi = [ 3 4 5 6 7]
        figure(fi)
            for regi=1:4
                subplot(2,2,figno(regi));
                p=polarhistogram((to_plot{regi, fi}),40,'visible','off');
                max_r = p.Parent.RLim(2);
                binCounts = p.BinCounts;
                binCenter = conv(p.BinEdges, [0.5 0.5], 'valid');
                binCounts = binCounts./sum(binCounts);
                polarplot( [binCenter binCenter(1)], [binCounts binCounts(1)],'linewidth',3)
%                 binMode = binCenter( binCounts == max(binCounts));
%                 binMode = binMode(1);
%                 hold on
%                 polarplot([binMode binMode], [0 max_r], 'r', 'LineWidth',2);
%                 hold off
                title(tit(regi))
                set(gca,'FontSize',16)
                %
                pval = circ_rtest((binCenter),binCounts, unique(diff(binCenter)));
                shannon_entropy(regi, fi-2, burstI) = binCounts*log2(binCounts)'+max_entropy;
                text(0.01,.01,"entropy : " + shannon_entropy(regi, fi-2, burstI),'Color','red')
            end
    end
end
%% 
