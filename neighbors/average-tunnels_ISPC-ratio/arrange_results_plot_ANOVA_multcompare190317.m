load regionwise_filtered_results
region_array = {'EC-DG','DG-CA3','CA3-CA1','CA1-EC'};
seggregated_results=cell(4,2);
for i=1:4                                                                   %seggregating results from the resulat_array table
    ind=strcmpi(result_array(:,3),region_array{i});
    regionwise_result = result_array(ind,:);
    ind_pair = strcmpi(regionwise_result(:,4),'pair');
    seggregated_results{i,1} = mean(cell2mat(regionwise_result(ind_pair,2)),1);
    seggregated_results{i,2} = mean(cell2mat(regionwise_result(not(ind_pair),2)),1);
end
%%
                                                                            %plotting ISPC for intra and inter tunnels
i=1;
    ax(i)=subplot(2,2,i);
    plot(smooth(seggregated_results{i,1}));
    hold on
    plot(smooth(seggregated_results{i,2}));
    title(region_array(i))
    ylim([0.3 1])
    xlim([1 298])
    set(gca,'fontsize',16)

i=2;
    ax(i)=subplot(2,2,i);
    plot(smooth(seggregated_results{i,1}));
    hold on
    plot(smooth(seggregated_results{i,2}));
    title(region_array(i))
    ylim([0.3 1])
    xlim([1 298])
    set(gca,'fontsize',16)

 i=3;
    ax(i)=subplot(2,2,i);
    plot(smooth(seggregated_results{i+1,1}));
    hold on
    plot(smooth(seggregated_results{i+1,2}));
    title(region_array(i+1))
    ylim([0.3 1])
    xlim([1 298])
    set(gca,'fontsize',16)

i=4;
    ax(i)=subplot(2,2,i);
    plot(smooth(seggregated_results{i-1,1}));
    hold on
    plot(smooth(seggregated_results{i-1,2}));
    title(region_array(i-1))
    ylim([0.3 1])
    xlim([1 298])
    set(gca,'fontsize',16)
    legend('Intra-tunnels','Inter-tunnels')

linkaxes(ax,'xy')
 %%
                                                                            %performing anova
 anova_table=zeros(length(seggregated_results{1}),length(region_array));
 for i=1:4
     anova_table(:,i)=(seggregated_results{i,1})'./(seggregated_results{i,2})';
 end
 figure(5)
 [p,tbl,stats] = anova1(anova_table);
 [c,m,h,gnames] = multcompare(stats);
     