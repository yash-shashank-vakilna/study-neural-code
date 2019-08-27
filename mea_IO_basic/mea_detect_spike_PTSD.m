function [ peak_train_array ] = mea_detect_spike_PTSD( mea, peakDuration, refrTime, multCoeff )
% Spike detection using PTSD for mea struct
%all times in ms

sf = mea.par.fs;
%convert ms to sf-units
peakDuration = peakDuration*sf/1e3; 
refrTime = refrTime*sf/1e3;

%initializing other variables
no_chan = length(mea.raw_data);
peak_train_array = cell(1, no_chan);
for chani = 1:no_chan
    data = double(mea.raw_data{chani});
    thresh = autComputTh(data,sf,multCoeff);
    
    % -----------------------------------------------------------------        
    % Calling the MEX file
    % -----------------------------------------------------------------
    [spkValues, spkTimeStamps] = SpikeDetection_PTSD_core(double(data)', thresh, peakDuration, refrTime);
    spikesTime  = 1 + spkTimeStamps( spkTimeStamps > 0 ); % +1 added to accomodate for zero- (c) or one-based (matlab) array indexing
    spikesValue = spkValues( spkTimeStamps > 0 );
    clear spkValues spkTimeStamps; % very large arrays.
     if ( any(spikesTime) ) % If there are spikes in the current signal
            % more efficient code, not creating train in memory: possible to make sparse array immediately. PL 05/09.
            peak_train = sparse(spikesTime,1,spikesValue,length(data),1);
            clear spikesTime spikesValue         % FREE the memory from the unuseful variables       
     else % If there are no spikes in the current signal
            peak_train = sparse(length(data), 1);
     end      
     peak_train_array{chani} = peak_train;
     fprintf('spikes detected for %d channel\n',chani);
end

end

