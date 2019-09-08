
% tunnelSetSeparatedResult = formatTunnelResultsbySeggregate (allregionresults);
% allregionresults = tunnelSetSeparatedResult;
to_plot = cell(1,4);
for regi = 1:4
    to_plot{regi} = cell(1,2);
    for fi = 3:7
        for chani = 1:length(allregionresults{fi}{regi})
            to_plot{regi}{1} = [ to_plot{regi}{1}  allregionresults{fi}{regi}{chani,1}];
            to_plot{regi}{2} = [ to_plot{regi}{2}  allregionresults{fi}{regi}{chani,2}];
            
        end
    end
end
    
%%
for regi = 1:4
    ind = to_plot{regi}{2} == 0;
    to_plot{regi}{1}(ind) = [];
    to_plot{regi}{2}(ind) = [];
end
%%
% tit = ["EC","DG","CA3","CA1"];
tit = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
figno = [1,2,4,3];
figure(1), clf
for regi=1:4
    y_max = 80;
    subplot(2,2,figno(regi))
    xbins = logspace(-3,1, 100);
    ybins = linspace(1,y_max,y_max);
    h=hist3(cell2mat( to_plot{regi}(:,1:2)')', 'CdataMode','auto','FaceColor','interp',...
        'Ctrs',{xbins ybins},'visible','off');
    imagesc(log10(h)')
    set(gca,'FontSize',16,'ydir','normal')
    hold on
    title(tit(regi))
    
    xlabel('Power (\muV^2)')
    ylabel('Spike Rate (s^{-1})')
    %transforming x-axis to log
    xtick_values = [1e-3, 1e-2, 1e-1, 1, 1e1];
    xtick_index = zeros(size(xtick_values));
    xbins_high_res = logspace(-3,1, 1000);
    for ticki = 1:length(xtick_values)
        temp = round(find(xbins_high_res > 0.9 * xtick_values(ticki) & ...
            xbins_high_res < 1.1 * xtick_values(ticki))./10);
        xtick_index(ticki) = (temp(1));
    end
    set(gca,'XTick',xtick_index,'XTickLabel', num2cell(xtick_values))
    xlim([2 inf])
    L = [ 0.1 2 10 20 30 50 100 200 500];
    l = log10(L);
    hC = colorbar;
    % Choose appropriate
    % or somehow auto generate colorbar labels
    set(hC,'Ytick',l,'YTicklabel',L);
    AX = gca;
    set(gca,'CLim',[l(1) l(end)])
    
    hold off
end
