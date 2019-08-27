load spikewaveform.mat
fs = 25e3;
desired_SR = 5;
ts = (1:length(spikewaveform))./fs;
translated_spike = circshift( spikewaveform, -round(fs/desired_SR ));
three_spikewaveform = spikewaveform + translated_spike;
translated_spike = circshift( spikewaveform, round(fs/desired_SR ));
three_spikewaveform = three_spikewaveform + translated_spike;
plot(ts, spikewaveform)