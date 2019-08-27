function [ three_spikewaveform] = translateANDcompute3spikes( spikewaveform, desired_SR)
%Translates spkewaveform to reproduce three spikes at desired spike rate
fs = 25e3;
translated_spike = circshift( spikewaveform, -round(fs/desired_SR ));
three_spikewaveform = spikewaveform + translated_spike;
translated_spike = circshift( spikewaveform, round(fs/desired_SR ));
three_spikewaveform = three_spikewaveform + translated_spike;

end

