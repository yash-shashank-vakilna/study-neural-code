cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\connectivity-hubness'
load ../data/'1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001'/spikes/mea_EC.mat
fs=25e3;
noChannels = length(mea.spike_data);
iScaleSegmentSize = 250*fs/1e3; %sf-units                                               %lower bound theta freq = 4Hz
iCorrelationWindow = 1e3*fs/1e3; %sf-units
CorrConnectivityMatrix = zeros(noChannels);
LagConnectivitymatrix = CorrConnectivityMatrix;
% chani=1; chanj=2;
for chani=1:noChannels
    for chanj=chani:noChann
        iTrialLength = 5*60*fs;
        iChannelSpikes = find(mea.spike_data{chani})';                 
        jChannelSpikes = find(mea.spike_data{chanj})';
        ReturnMatrix = ComputeScaledCC_BB...
            (iScaleSegmentSize,iCorrelationWindow,iTrialLength,iChannelSpikes,jChannelSpikes,0);
        cor = ReturnMatrix(1,:);
        lags=-iCorrelationWindow:1:iCorrelationWindow;
        lags = lags.*(1e3/fs);                                              %converting to ms
        CorrConnectivityMatrix(chani, chanj) = max(cor);
        maxLagI = find (cor == max(cor));
        LagConnectivitymatrix(chani, chanj) = lags(maxLagI(1));
    end
end
