function [ result_array ] = compute_ISPC_neighbor_subset_190418( ref_mea, channel_name_list, threshold_distance, time_scale )
%Computes ISPC for each channel of ref_mea with all the neighbors specified
%by threshold distance (1=4-connected, sqrt(2)=8-connected )
fs=ref_mea.par.down_fs;
n_total=0;
result_array={};
channel_index_list = zeros(1,length(channel_name_list));
for chani = 1:length(channel_name_list)
    channel_index_list(chani) = find(strcmpi(ref_mea.channel_names,channel_name_list{chani}));
end

for ref_no=1:length(channel_index_list)
    ref_chan_i = channel_index_list(ref_no);
    neighbor_index=[];
    ref_coordinate=ref_mea.coordinates{ref_chan_i};
    
    for neigh_no = ref_no:length(channel_index_list)                                          %finding index of the neighboring channels
        neigh_chan_j = channel_index_list(neigh_no); 
        dist = find_distance(ref_coordinate,ref_mea.coordinates{neigh_chan_j});
        if ((dist>0) && (dist<=threshold_distance))
            neighbor_index=[neighbor_index neigh_chan_j];
        end 
    end
    
    if(isempty(neighbor_index))                                            %skipping channels with no neighbors
        disp(strcat(ref_mea.channel_names{ref_chan_i},' skipped'))
        continue;
    end
    
    
    for neigh_chan_j=neighbor_index
        if ~exist('time_scale','var')
        time_scale= 1; %s                                                 %lowest frequency for theta range                                                                        
        disp 'computing ISPC for time-scale = 1s'
        end
         [coher_val, ts] = compute_ISPC(ref_mea.filtered_data{ref_chan_i},...
             ref_mea.filtered_data{neigh_chan_j}, time_scale,fs,1);          %compute ISPC for the neighbors 
         title_name=sprintf('%s - %s',ref_mea.channel_names{ref_chan_i},...
             ref_mea.channel_names{neigh_chan_j});
         dist = find_distance(ref_coordinate,ref_mea.coordinates{neigh_chan_j});
         result_array=[result_array;{title_name, coher_val, dist}];              %storing results
         disp(strcat(title_name,' worked'))
        n_total=n_total+1;
    end
end
result_array=[result_array;{'time_series', ts,0}];

end

