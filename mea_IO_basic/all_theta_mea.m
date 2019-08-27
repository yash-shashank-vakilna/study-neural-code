cd '\\BREWERSERVER\Shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\theta_filtered'
f = dir('*.mat');
clear mea; clear theta_array;
load(f(1).name);
theta_array = rmfield(mea,{'raw_data','peak_train'});
for fi = 2:length(f)
    load(f(fi).name)
    theta_array = concatenate_mea(theta_array, mea);
end
save theta_mea theta_array 