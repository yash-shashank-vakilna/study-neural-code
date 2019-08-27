function [nochan, nspikes] = meaNSpikes(mea)
%Takes in the mea and gives total no. of spikes
nspikes = 0; nochan = 0;
try
    spikeData = mea.spike_data;
catch
    disp("mea spike data does not exist")
    return
end

for chani=1:length(spikeData)
    nochan = nochan + any(spikeData{chani});
    nspikes = nspikes + length(find(spikeData{chani}));

end

