% load \\BREWERSERVER\Shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\filtered_mea_tunnels.mat 
chan_name_1 = 'K7';
chan_name_2 = 'J7';
%%
[ burst_ISPC_train, non_burst_ISPC_train ] = comparison_ISPC_during_burst_190411(mea, chan_name_1, chan_name_2 );
%%
%Anova and bar_plot
anova_values = [burst_ISPC_train, non_burst_ISPC_train];
anova_labels = [repmat({'Burst'},1,length(burst_ISPC_train)), repmat({'Non-burst'}, 1,length(non_burst_ISPC_train))];
anova1(anova_values, anova_labels)
%%
%Bar plot
bar([mean(burst_ISPC_train) mean(non_burst_ISPC_train)])
hold on
errorbar(1:2,[mean(burst_ISPC_train) mean(non_burst_ISPC_train)],...
    [std(burst_ISPC_train)./sqrt(length(burst_ISPC_train)) std(non_burst_ISPC_train)./sqrt(length(non_burst_ISPC_train))],'.r')
xticklabels({'Burst segments','Non-burst segments'})
ylabel('Phase synchrony (ISPC (AU))')
set(gca, 'FontSize', 16)