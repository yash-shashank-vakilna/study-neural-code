cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\data'
folderAddr = dir('*0001');
folderAddr = {folderAddr.name};
fs = 25e3; msInSf = fs/1e3;
for fI=1:length(folderAddr)
    cd(folderAddr{fI}+"/raw-mea")
%     mkdir('spikes')
    meaAddr = dir('mea*mat');
    for meaI = 1:5
        rawMea = load(meaAddr(meaI).name);
        [ filtered_mea] = highpass_filter_mea_190521(rawMea.mea,300 );
        peakDuration = 1; refrTime = 1.6; multCoeff = 9;
        peak_train_array = mea_detect_spike_PTSD( filtered_mea , peakDuration, refrTime, multCoeff);
        rawMea.mea.spike_data = peak_train_array;
        nspikes = 4;ISImax = 50;min_mbr = 0.4;
        [ burstCell ] = mea_detect_burst( rawMea.mea,  nspikes, ISImax, min_mbr  );
        rawMea.mea.burst_data = burstCell;
        mea = rawMea.mea;
        save("../spikes/" + meaAddr(meaI).name, 'mea','-v7.3')
        disp("spikes detected:"+meaI)
    end
    disp("folder processed:"+fI)
    cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\data'
end
    