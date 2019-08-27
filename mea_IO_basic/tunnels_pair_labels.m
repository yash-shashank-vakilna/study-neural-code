%create theta array by concatenating all theta signals
% all_theta_mea
coordinates = theta_array.coordinates;
[ tunnels_result_array ] = compute_ISPC_neighbor_190228( theta_array, theta_array, 1 );
no_time_points = length(tunnels_result_array{1,2});
%%
%remove tunnels pairs
load tunnels_ISPC_labels
tunnels_ISPC_labels(strcmpi(tunnels_ISPC_labels(:,3),'adj'),:)=[];
tunnels_ISPC_labels(strcmpi(tunnels_ISPC_labels(:,3),'none'),:)=[];
tunnels_ISPC_labels(end,:)=[];
tunnels_pairs= tunnels_ISPC_labels;
for pairi =1:length(tunnels_pairs)
    ind = strcmpi(tunnels_pairs(:,1),tunnels_pairs(pairi));
    tunnels_pairs(ind,:) = [];
end
%%
%remove inappropriate channels
channel_connectivity = theta_array.channel_names;
channel_connectivity(:,3) = coordinates;
channels2remove = {'F6','F7','G6','G7'};
for chani =  1:length(channels2remove)
    channel_connectivity(strcmpi(channel_connectivity, channels2remove{chani}),:)=[];
end

for chani = 1:length(channel_connectivity)
    channel_connectivity{chani,2} = zeros(1, no_time_points);
end
%using channel_names to find sum 4-cell connectivity for every subregion 
%and 2-cell connectivity for every subregion
for chani = 1:length(channel_connectivity)
    for pairi = 1:length(tunnels_result_array)
        if logical(cell2mat(strfind(tunnels_result_array(pairi,1),channel_connectivity{chani,1})))
            channel_connectivity{chani,2} = channel_connectivity{chani,2}...
                + tunnels_result_array{pairi,2};
        end
    end
end
%dividing subregions be 4 and tunnels by 2 
for chani = 1:length(channel_connectivity)
    if (any((strfind(channel_connectivity{chani,1},'A6')))) 
        channel_connectivity{chani,2} = channel_connectivity{chani, 2}./2;
    else
        channel_connectivity{chani,2} = channel_connectivity{chani, 2}./4;
    end
end
%%
connectivity_with_time = zeros(12,12,no_time_points);                       %initializing channel_space matrix
%putting data in appropriate place based on their coordinates
for chani = 1:length(channel_connectivity)
    connectivity_with_time(channel_connectivity{chani,3}(1),...
        channel_connectivity{chani,3}(2),:) = channel_connectivity{chani,2};
end
%%
%create video by updating cdata of the figure
im = imagesc(rand(12,12));
for ti=1:no_time_points
    im.CData = connectivity_with_time(:,:,ti);
    pause(0.1)
end
