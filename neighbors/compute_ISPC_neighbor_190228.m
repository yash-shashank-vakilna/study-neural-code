function [ result_array ] = compute_ISPC_neighbor_190228( ref_mea, neighbor_mea, threshold_distance, time_scale )
%Computes ISPC for each channel of ref_mea with all the neighbors specified
%by threshold distance (1=4-connected, sqrt(2)=8-connected )
fs=ref_mea.par.down_fs;
n_total=0;
result_array={};
for ref_i=1:length(ref_mea.filtered_data)
    neighbor_index=[];
    ref_coordinate=ref_mea.coordinates{ref_i};
    
    for neigh_j=ref_i:length(neighbor_mea.filtered_data)                    %finding index of the neighboring channels
        dist = find_distance(ref_coordinate,...
            neighbor_mea.coordinates{neigh_j});
        if ((dist>0) && (dist<=threshold_distance))
            neighbor_index=[neighbor_index neigh_j];
        end 
    end
    
    if(isempty(neighbor_index))                                            %skipping channels with no neighbors
        disp(strcat(ref_mea.channel_names{ref_i},' skipped'))
        continue;
    end
    
    
    for neigh_j=neighbor_index
        if ~exist('time_scale','var')
        time_scale= 1; %s                                                 %lowest frequency for theta range                                                                        
        disp 'computing ISPC for time-scale = 1s'
        end
         [coher_val, ts] = compute_ISPC(ref_mea.filtered_data{ref_i},...
             neighbor_mea.filtered_data{neigh_j}, time_scale,fs,1);                %compute ISPC for the neighbors 
         title_name=sprintf('%s - %s',ref_mea.channel_names{ref_i},...
             neighbor_mea.channel_names{neigh_j});
         result_array=[result_array;{title_name, coher_val}];              %storing results
         disp(strcat(title_name,' worked'))
        n_total=n_total+1;
    end
end
result_array=[result_array;{'time_series', ts}];

end

