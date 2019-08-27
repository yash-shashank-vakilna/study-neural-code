cd('C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\ISPC-spike-LFP\results')
for regi = 1:4
    for chani = 1:length(allregionresults{regi})
        if isempty(allregionresults{regi}{chani,2})
            continue
        end
        polarhistogram(allregionresults{regi}{chani,2},20)
        tit = "Region-"+regi+" Chani-"+spikeMEA.mea.channel_names{chani};
        title("Angle histogram for:"+tit)
        saveas(gcf,char(tit),'png')
    end
end

%%
to_plot=cell(1,4);
for fi=3:7
    for regi=1:4
        to_plot{regi} = [to_plot{regi};  cell2mat(allregionresults{fi}{regi}(:,1))];
    end
end
for regi=1:4
    to_plot{regi}(isnan(to_plot{regi})) = [];
end
%%
figno = [1 2 4 3];
tit = ["EC","DG","CA3","CA1"];
for regi=1:4
    figure(1)
    subplot(2,2,figno(regi));
    p=polarhistogram(angle(to_plot{regi}),20);
    title(tit(regi))
    set(gca,'FontSize',16)
%     rlim([0 25])
end
%%
