to_plot = cell(1,4);

for regi = 1:4
    to_plot{regi} = cell(1,3);
    for fi = 3:7
        for chani = 1:length(tunnelResultRegion{fi}{regi})
            to_plot{regi}{1} = [ to_plot{regi}{1}  tunnelResultRegion{fi}{regi}{chani,1}];
            to_plot{regi}{2} = [ to_plot{regi}{2}  tunnelResultRegion{fi}{regi}{chani,2}];
            to_plot{regi}{3} = [to_plot{regi}{3} repmat(fi, 1, length(tunnelResultRegion{fi}{regi}{chani,2}))];
        end
    end
end
    
%%
for regi = 1:4
    ind = to_plot{regi}{2} == 0;
    to_plot{regi}{1}(ind) = [];
    to_plot{regi}{2}(ind) = [];
    to_plot{regi}{3}(ind) = [];
end
%%
tit = ["EC-DG", "DG-CA3", "CA3-CA1", "CA1-EC"];
fig_no = [1 2 4 3];
figure(1)
for regi = 1:4
    p(regi)=subplot(2,2,fig_no(regi));
    for fi = 3:7
        ind = to_plot{regi}{3} == fi;
        scatter(to_plot{regi}{1}(ind), to_plot{regi}{2}(ind),'.')
        hold on
    end
    hold off
    ylabel('Spike Rate (spikes/s)')
    xlabel('Power (\muV^2)')
    title(tit(regi));
    set(gca,'FontSize',16, 'xscale','log')
end
linkaxes(p,'x')
    