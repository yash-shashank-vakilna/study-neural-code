function [ result_array ] = compute_xcov_neighbor_subset_190418( ref_mea, target_mea, channel_name_list,  time_scale )
%Computes cross-correlation for each channel of ref_mea with all the neighbors specified
%by threshold distance (1=4-connected, sqrt(2)=8-connected )

fs=ref_mea.par.down_fs;
channel_index_list = zeros(length(channel_name_list),2);

%Computing channel indices
for chani = 1:length(channel_name_list)
    right_chan_no = find_in_channel_list(ref_mea.mea.channel_names, channel_name_list{chani, 1});
    left_chan_no = find_in_channel_list(target_mea.mea.channel_names, channel_name_list{chani, 1});
    if (~isempty(right_chan_no) && ~isempty(left_chan_no))
        channel_index_list(chani) = [left_chan_no, right_chan_no];
    end
end
result_array = cell(length(channel_index_list),3);
for pairi=1:length(channel_index_list)
     [lag_w_time, corr_w_time, ts] = compute_xcov_2_channels(ref_mea.filtered_data{ref_chan_i},...
         ref_mea.filtered_data{neigh_chan_j}, time_scale,fs,1);            %compute ISPC for the neighbors 
     title_name=sprintf('%s - %s',ref_mea.channel_names{channel_index_list{pairi, 1}},...
         target_mea.channel_names{channel_index_list{pairi, 1}});
     result_array{pairi,1} = lag_w_time;                                %storing results
     result_array{pairi,2} = corr_w_time;
     result_array{pairi3} = title_name;
     disp(strcat(title_name,' worked'))
end
result_array{pairi,1}=ts;
result_array{pairi,3}='time-series';

end

