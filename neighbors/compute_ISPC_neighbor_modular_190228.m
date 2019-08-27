
cd('\\BREWERSERVER\Shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19914_160127_160217_d21_5minspont0001\stuct_files')


% load('mea_tunnels.mat');
% mea_tunnels=filter_mea_190308(mea_tunnels,4,11);
% fs = 25e3;
load filtered_mea_tunnels.mat
[ tunnels_result_array ] = compute_ISPC_neighbor_190228( mea, mea , 1 );
%%
