cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
cd './1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001/raw-mea'
spikeMEA = load('mea_EC');
cd ../spikes
rawMEA = load('mea_EC');
fs = rawMEA.mea.par.fs; chani=1;
spikeSnippet = getSpikeSnippets(spikeMEA.mea.spike_data{chani}, rawMEA.mea.raw_data{chani}, 1, fs);
%% STFT
spikI = 300;
ts =0:1/25e3:2;
figure(2),clf
p(1)=subplot(211);
plot(ts, spikeSnippet{spikI})
title("Short-time Fourier transform of a spike cutout in channel A4 for spike-count = "+spikI)
hold on 
p(2)=subplot(212);
spectrogram(double(spikeSnippet{spikI}), hamming(2^nextpow2(fs/100)), [],...
    [4:5:300], 25e3, 'yaxis','MinThreshold',-10)
linkaxes(p,'x')
hold off
%% CWT
spikI = 300;
ts =0:1/25e3:2;
figure(2),clf
p(1)=subplot(211);
x= double(spikeSnippet{spikI});
x = zscore(x);
plot(ts, x)
title("Short-time Fourier transform of a spike cutout in channel A4 for spike-count = "+spikI)
hold on 
p(2)=subplot(212);
%% CWT
[wt,f]=cwt(x,'amor',25e3);
cwt(x,'amor',25e3)
% minf = 2e-3; maxf = 256e-3;
AX = gca;
freq = log2([4 11 30 140 300].*1e-3);
% freq = (round(log2(minf)):round(log2(maxf)));
% AX.YTickLabelMode = 'auto';
AX.YTick = freq;
AX.YLim = [-inf log2(300e-3)];
AX.YTickLabel = ["4","11","30","140","300"];
AX.CLim = [0.05 0.6];
AX.YLabel.String = "Frequency (Hz)";
%%
linkaxes(p,'x')
hold off
