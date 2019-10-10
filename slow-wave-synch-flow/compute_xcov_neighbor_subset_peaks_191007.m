function [ result_array ] = compute_xcov_neighbor_subset_peaks_191007( ref_mea, target_mea, channel_name_list,  time_scale , if_zscore)
%Computes cross-correlation for each channel of ref_mea with all the neighbors specified
%by threshold distance (1=4-connected, sqrt(2)=8-connected )
% time-scale 

fs=ref_mea.par.down_fs;
channel_index_list = zeros(length(channel_name_list),2);

% Get peaks of filtered_data
peakDuration = time_scale; refrTime = time_scale; multCoeff = 16;
% time_scale = 500ms for theta
[ ref_mea.filter_spike ] = mea_detect_peaks_filtered_PTSD( ref_mea, peakDuration, refrTime, multCoeff );
[ target_mea.filter_spike ] = mea_detect_peaks_filtered_PTSD( target_mea, peakDuration, refrTime, multCoeff );

%Computing channel indices array, essentially, converting channel names to
%indices
for chani = 1:length(channel_name_list)
    right_chan_no = find_in_channel_list(ref_mea.channel_names, channel_name_list{chani, 2});
    left_chan_no = find_in_channel_list(target_mea.channel_names, channel_name_list{chani, 1});
    if (~isempty(right_chan_no) && ~isempty(left_chan_no))
        channel_index_list(chani,:) = [left_chan_no, right_chan_no];
    end
end
result_array = cell(length(channel_index_list),3);
%computing synchflow
for pairi=1:length(channel_index_list)
     [corr_w_time, lag_w_time, ts] = compute_xcov_2_channels_peaks...
         (ref_mea.filtered_data{channel_index_list(pairi,1)}, target_mea.filtered_data{channel_index_list(pairi,2)},... 
     ref_mea.filter_spike{channel_index_list(pairi,1)}, target_mea.filter_spike{channel_index_list(pairi,2)},...
     time_scale, fs, if_zscore);            %compute xcov for the neighbors
     % negative lag means channel_name_list(2,:)(%%right%%) is leading 
     % positive lag means channel_name_list(1,:)(%%left%%) is leading
     title_name=sprintf('%s - %s',ref_mea.channel_names{channel_index_list(pairi, 1)},...
         target_mea.channel_names{channel_index_list(pairi, 2)});
     result_array(pairi,:) = {corr_w_time, lag_w_time, title_name};                                %storing results
     disp(strcat(title_name,' worked'))
end
result_array{pairi+1,1}=ts;
result_array{pairi+1,3}='time-series';

end

