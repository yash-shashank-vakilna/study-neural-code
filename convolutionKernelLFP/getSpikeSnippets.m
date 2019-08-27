function spikeSnippet = getSpikeSnippets(spike_train, raw_data, n_sec_cutout, fs)
%gets spike snippets from data pointed by spike train
spikeTimeStamps = find(spike_train);
no_spikes = length(spikeTimeStamps);
spikeSnippet = cell(1, no_spikes);
for spikyI = 1:no_spikes
    SnipStart =  max([1 spikeTimeStamps(spikyI)-n_sec_cutout*fs]);
    SnipStop =  min([300*fs spikeTimeStamps(spikyI)+n_sec_cutout*fs]);
    spikeSnippet{spikyI} = raw_data(SnipStart: SnipStop);
end

    
end
