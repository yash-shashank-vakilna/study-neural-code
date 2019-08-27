%performs ISPC on the new array
 load \\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\gamma_filtered\gamma_filtered_mea_tunnels.mat
channels_sets_to_work = {{'A7','B7','C7','D7','E7'}; {'F1','F2','F3','F4','F5'};...
     {'H6','J6','K6','L6','M6'}; {'G8','G9','G10','G11','G12'}}; 
 tunnel_result_array_set = cell(1,length(channels_sets_to_work));
 for seti = 1:length(tunnel_result_array_set)
     tunnel_result_array_set{seti}  = compute_ISPC_neighbor_subset_190418( mea, channels_sets_to_work{seti} , 4 ,0.15); %computing ISPC for 10s interval
 end
%%
tunnel_mean_set = cell(1, length(tunnel_result_array_set));
for seti = 1 : length(tunnel_mean_set)
    mean_coher = zeros(length(tunnel_result_array_set{seti})-1,1);
    dist_array = zeros(length(mean_coher),1);
    for pairi = 1:length(tunnel_result_array_set{seti})-1
        mean_coher(pairi) = mean(tunnel_result_array_set{seti}{pairi,2});
        dist_array(pairi) = 0.2*tunnel_result_array_set{seti}{pairi,3};
    end
    tunnel_mean_set{seti} = [dist_array, mean_coher];
end
        


