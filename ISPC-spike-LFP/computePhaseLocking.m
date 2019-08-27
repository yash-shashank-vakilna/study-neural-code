function [ meanV,  spikeAngleDistro] = computePhaseLocking ( peak_train, LFP_train )
%for all the angles corresponding to non-zero values of peak train, the
%code extracts angle series using hilbert transform 

angleS = angle(hilbert(LFP_train));

spikeAngleDistro = angleS.*sign(peak_train);
spikeAngleDistro( spikeAngleDistro == 0) = [];
spikeAngleDistro = full(spikeAngleDistro);
meanV = mean(exp(1i*(spikeAngleDistro)));


end

