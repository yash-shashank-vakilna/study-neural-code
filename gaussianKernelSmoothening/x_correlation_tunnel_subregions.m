cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001\theta-mea'
%concatenating data
tunnelMea = load('./filtered_mea_tunnels.mat');
subNames = {'./filtered_mea_EC.mat', './filtered_mea_DG.mat', './filtered_mea_CA3.mat', './filtered_mea_CA1.mat'};
subLFPcell = {}; channelNameCell = {}; coordinatesCell = {};
for subi = 1:4
    subMea = load(subNames{subi});
    subLFPcell = [subLFPcell; subMea.mea.filtered_data];
    channelNameCell = [channelNameCell; subMea.mea.channel_names];
    coordinatesCell = [coordinatesCell; subMea.mea.coordinates];
    clear subMea
end
%initializing variables
fs = 25e3;
ts = 1/fs:1/fs:300;
gaussWidth = 32e-3;%s
maxLags = 1*fs;
%% computing
allChannelResults = {}; resI = 1;
for chani = 1:length(tunnelMea.mea.spike_data)
    for chanj = 1:length(subLFPcell)
        distance = find_distance(tunnelMea.mea.coordinates{chani}, coordinatesCell{chanj});
        if distance <= 1 && distance > 0
            [ gaussSpikeData] = gaussianKernelMoving(tunnelMea.mea.spike_data{chani}, gaussWidth, fs);
            [corrc,lags] = xcov(gaussSpikeData, subLFPcell{chanj}, maxLags);
            allChannelResults{resI, 1} = corrc ;
            allChannelResults{resI, 2} = "spikes -> "+tunnelMea.mea.channel_names{chani}+ " | LFP -> " + channelNameCell{chanj} ;
            disp(allChannelResults{resI, 2}+" processed")
            resI = resI + 1;
        end
    end
end
allChannelResults{resI, 1} = lags*1e3/fs;
allChannelResults{resI, 2} = "lags";    
%% 
for i=1:40
    maxInd = find(abs(allChannelResults{i,1}) == max(abs(allChannelResults{i,1})));
    allChannelResults{i,3}=allChannelResults{41}(maxInd);
end
