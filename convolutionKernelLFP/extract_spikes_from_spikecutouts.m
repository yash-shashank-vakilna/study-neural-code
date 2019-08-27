function [spikeWaveform] = extract_spikes_from_spikecutouts(spikeCutOut,ts,n_ms)
%Remove spikes from the waveform
fs = 25e3;
spikeWaveform = zeros(1, length(spikeCutOut));
ind = find (ts == 1);
spikeWaveformWidth = round(n_ms*1e-3*fs);
if length(n_ms) < 2
    spikeWaveform(ind-spikeWaveformWidth: ind+spikeWaveformWidth) = ...
        spikeCutOut(ind-spikeWaveformWidth: ind+spikeWaveformWidth);
else
    spikeWaveform(ind-spikeWaveformWidth(1): ind+spikeWaveformWidth(2)) = ...
        spikeCutOut(ind-spikeWaveformWidth(1): ind+spikeWaveformWidth(2));

end

