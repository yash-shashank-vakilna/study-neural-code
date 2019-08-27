load \\BREWERSERVER\Shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\filtered_mea_tunnels.mat 
chan_no = find(strcmpi(mea.channel_names,{'L7'}));
chan_no = [chan_no; find(strcmpi(mea.channel_names,{'M7'}))];

%detect bursts
burst_cell = cell(length(chan_no),1);
nspikes = 4;ISImax = 50;min_mbr = 0.4;
for chani=1:length(chan_no)
    [ burst_detection,  burst_event, outburst_cell] = detectBurst_singleChannel_190409(mea.peak_train{chan_no(chani)}, nspikes, ISImax, min_mbr );
    burst_cell{chani} = convert_to_burst_train_190410(burst_detection, length(mea.peak_train{1}));
end
%%
% filter w/o downsample
filtered_mea = create_mea(2);
filtered_mea.raw_data{1}=mea.raw_data{chan_no(1)};
filtered_mea.raw_data{2}=mea.raw_data{chan_no(2)};
[ filtered_mea] = filter_mea_190308(filtered_mea, 4, 11, 0);

%%
% AND burst and seggregate data
both_burst = burst_cell{1} & burst_cell{2};
burst_data = [double(filtered_mea.filtered_data{(1)}(both_burst))';...
    double(filtered_mea.filtered_data{(2)}(both_burst))'];
non_burst_data = [double(filtered_mea.filtered_data{(1)}(not(both_burst)))';...
    double(filtered_mea.filtered_data{(2)}(not(both_burst)))'];

%%
%compute ISPC
burst_ISPC_train = compute_ISPC(burst_data(1,:)',burst_data(2,:)', 1,25e3, 1);
non_burst_ISPC_train = compute_ISPC(non_burst_data(1,:)',non_burst_data(2,:)', 1,25e3, 1);

%%
%Anova and bar_plot
anova_values = [burst_ISPC_train, non_burst_ISPC_train];
anova_labels = [repmat({'Burst'},1,length(burst_ISPC_train)), repmat({'Non-burst'}, 1,length(non_burst_ISPC_train))];
anova1(anova_values, anova_labels)
%%
bar([mean(burst_ISPC_train) mean(non_burst_ISPC_train)])
hold on
errorbar(1:2,[mean(burst_ISPC_train) mean(non_burst_ISPC_train)],...
    [std(burst_ISPC_train)./sqrt(length(burst_ISPC_train)) std(non_burst_ISPC_train)./sqrt(length(non_burst_ISPC_train))],'.r')
xticklabels({'Burst segments','Non-burst segments'})
ylabel('Phase synchrony (ISPC (AU))')
set(gca, 'FontSize', 16)

% %%
% %AND both bursts
% both_burst_train  = burst_cell{1} & burst_cell{2};
% 
% %%
% %seggregate burst and non burst 
% for chani = 1:2
%     burst_data(chani,:) = mea.filtered_data{chan_no(chani)}(down_burst_train);
% end
% 
% for chani = 1:2
%     non_burst_data(chani,:) = mea.filtered_data{chan_no(chani)}(not(down_burst_train));
% end
% 
% %compute ISPC 
% filtered_sf = mea.par.down_fs;
% down_burst_train = downsample(both_burst_train,250);
% down_burst_train = down_burst_train(1*filtered_sf : length(down_burst_train)-1*filtered_sf-1);
% burst_ISPC_train = compute_ISPC(burst_data(1,:),burst_data(2,:), 1,filtered_sf,1);
% non_burst_ISPC_train = compute_ISPC(non_burst_data(1,:),non_burst_data(2,:), 1,filtered_sf,1);
%     
% %%
% %Anova and bar_plot
% anova_values = [burst_ISPC_train, non_burst_ISPC_train];
% anova_labels = [repmat({'Burst'},1,length(burst_ISPC_train)), repmat({'Non-burst'}, 1,length(non_burst_ISPC_train))];
% anova1(anova_values, anova_labels)
