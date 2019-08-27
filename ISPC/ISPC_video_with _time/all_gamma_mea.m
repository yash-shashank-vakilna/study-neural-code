cd '\\BREWERSERVER\Shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\gamma_filtered\'
f = dir('*.mat');
clear mea; clear gamma_mea;
load(f(1).name);
gamma_mea = rmfield(mea,{'raw_data','peak_train'});
for fi = 2:length(f)
    load(f(fi).name)
    gamma_mea = concatenate_mea(gamma_mea, mea);
end
save theta_mea gamma_mea 