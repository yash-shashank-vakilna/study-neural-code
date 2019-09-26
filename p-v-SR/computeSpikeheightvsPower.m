function [ spikeHeight, spike_triggered_insta_power, spike_triggered_insta_phase] = computeSpikeheightvsPower...
    (spike_data, LFP_power )
%Computes instantaneous power, phase and spike width

[spikeI,~,spikeHeight] = find(spike_data);
hilb_trans = hilbert(LFP_power);
insta_power = abs(hilb_trans);
insta_phase = angle(hilb_trans);
spike_triggered_insta_power = insta_power(spikeI);
spike_triggered_insta_phase = insta_phase(spikeI);

end

