function [ burst_cell ] = mea_detect_burst( mea,  nspikes, ISImax, min_mbr  )
%burst detection using PTSD for mea struct

no_chan = length(mea.spike_data);
burst_cell = cell( no_chan,1);

for chani = 1:no_chan
    [ burst_detection,  ~, ~] = detectBurst_singleChannel_190409(mea.spike_data{chani}, nspikes, ISImax, min_mbr );
    burst_cell{chani} = convert_to_burst_train_190410(burst_detection, length(mea.spike_data{chani}));
    fprintf('burst detected for %d channel\n',chani);
end

end
