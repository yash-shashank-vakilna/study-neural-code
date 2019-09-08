function [ spikeHeight, spike_triggered_insta_power] = computeSpikeheightvsPower...
    (spike_data, LFP_power )
%Computes instantaneous power and spike width

[spikeI,~,spikeHeight] = find(spike_data);
insta_power = abs(hilbert(LFP_power));
spike_triggered_insta_power = insta_power(spikeI);

end

