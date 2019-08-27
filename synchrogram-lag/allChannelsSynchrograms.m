load '//brewerserver/shared/Yash/SCA-spike-lfp-theta/data/1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001/theta-mea/filtered_mea_EC.mat'
timeScale = 0.04; %ms
maxLag = 10; %ms
fs = 25e3;
overlap =0;
noChannels = length(mea.filtered_data);
synchrogramResults = cell(nchoosek(noChannels,2)+1,2);
synchI = 1;
for chani = 1:noChannels
    for chanj = chani:noChannels
        distance = find_distance(mea.coordinates{chani}, mea.coordinates{chanj});
        if distance < sqrt(2)
            [synchrogram,lags] = computeSynchrogram(mea.filtered_data{chani}, mea.filtered_data{chanj},...
                timeScale, maxLag, fs, overlap);
            synchrogramResults{synchI, 1} = synchrogram;
            synchrogramResults{synchI, 2} = mea.channel_names{chani} + " - "+ mea.channel_names{chanj};
            disp(synchrogramResults{synchI, 2}+" processed")
            synchI = synchI +1;
        end
    end
    synchrogramResults{synchI, 1} = lags;
    synchrogramResults{synchI, 2} = "time-series";
end
    