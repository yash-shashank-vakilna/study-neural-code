function [ burst_ISPC_train, non_burst_ISPC_train ] = comparison_ISPC_during_burst_190411(mea, chan_name_1, chan_name_2 )
%detects bursts, then seggregate data for periods when both channels have bursts  
%then filters theta and computes ISPC 

chan_no = find(strcmpi(mea.channel_names,chan_name_1));
chan_no = [chan_no; find(strcmpi(mea.channel_names,chan_name_2))];

%detect bursts
burst_cell = cell(length(chan_no),1);
nspikes = 4;ISImax = 50;min_mbr = 0.4;
for chani=1:length(chan_no)
    [ burst_detection,  ~, ~] = detectBurst_singleChannel_190409...
        (mea.peak_train{chan_no(chani)}, nspikes, ISImax, min_mbr );
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

end
