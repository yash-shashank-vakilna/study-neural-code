%% Remove 0s in sr
for regi=1:4
    to_plot{regi}(to_plot{regi}(:,2) == 0,:) =[];
end
%%
tit = ["EC","DG","CA3","CA1"];
% tit = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
figno = [1,2,4,3];
figure(1), clf
for regi=1%:4
    xbins = logspace(-3,1, 100);
    hist3(to_plot{regi}(:,1:2), 'CdataMode','auto','FaceColor','interp',...
        'Ctrs',{xbins linspace(1,200,200)},'visible','on')
    set(gca,'XScale','log','FontSize',16)
    view(2)
    hold on
    title(tit(regi))
    xlabel('Power (\muV^2)')
    ylabel('Spike Rate (s^{-1})')
%         xlim([0.3 1400])


end
% linkaxes(p,'xy')
% hold off
% legend({'ECDGCA3CA1 24574 160727 160818 d22 5minspont0001','ECDGCA3CA1 19914 160127 160303 d37 5minspont0001',...
%     'ECDGCA3CA1 24088 160127 160302 d36 5minspont0001', 'ECDGCA3CA1 19908 150729 150823 d25 5minspont0001', 'ECDGCA3CA1 19914 150805 150828 d25 5minspont0001'})