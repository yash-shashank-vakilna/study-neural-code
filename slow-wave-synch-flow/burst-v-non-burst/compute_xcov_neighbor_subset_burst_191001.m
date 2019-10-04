function [ result_array ] = compute_xcov_neighbor_subset_burst_191001( ref_mea,channel_name_list,  time_scale , overlap, if_burst)
%Computes cross-correlation for each channel of ref_mea with all the neighbors specified
%by threshold distance (1=4-connected, sqrt(2)=8-connected )

fs=ref_mea.par.down_fs;
channel_index_list = zeros(length(channel_name_list),2);

%Computing channel indes array, essentially, converting channel names to
%indices
for chani = 1:length(channel_name_list)
    right_chan_no = find_in_channel_list(ref_mea.channel_names, channel_name_list{chani, 2});
    left_chan_no = find_in_channel_list(ref_mea.channel_names, channel_name_list{chani, 1});
    if (~isempty(right_chan_no) && ~isempty(left_chan_no))
        channel_index_list(chani,:) = [left_chan_no, right_chan_no];
    end
end
result_array = cell(length(channel_index_list),3);
%computing synchflow
for pairi=1:length(channel_index_list)
    if if_burst
        both_burst = ref_mea.burst_data{channel_index_list(pairi,1)} & ...
            ref_mea.burst_data{channel_index_list(pairi,2)};
    else
        both_burst = ~ref_mea.burst_data{channel_index_list(pairi,1)} & ...
            ~ref_mea.burst_data{channel_index_list(pairi,2)};
    end
     [corr_w_time, lag_w_time, ts] = compute_xcov_2_channels...
         (ref_mea.filtered_data{channel_index_list(pairi,1)}(both_burst),...
         ref_mea.filtered_data{channel_index_list(pairi,2)}(both_burst), time_scale,fs,overlap);            %compute xcov for the neighbors
     % negative lag means channel_name_list(2,:)(%%right%%) is leading 
     % positive lag means channel_name_list(1,:)(%%left%%) is leading
     title_name=sprintf('%s - %s',ref_mea.channel_names{channel_index_list(pairi, 1)},...
         ref_mea.channel_names{channel_index_list(pairi, 2)});
     result_array(pairi,:) = {corr_w_time, lag_w_time, title_name};                                %storing results
     disp(strcat(title_name,' worked'))
end
result_array{pairi+1,1}=ts;
result_array{pairi+1,3}='time-series';

end

