%% Lowpass filter data to 300 Hz
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\3ECDGCA3CA1 24574 160727 160818 d22 5minspont0001\raw-mea'
load mea_tunnels.mat
fs = mea.par.fs;
x = double(mea.raw_data{1});
clear mea
t = 1/fs:1/fs:300;
low_x = lowpass(x, 300, fs,"ImpulseResponse",'fir','Steepness',0.95);
load ../spikes/mea_tunnels.mat
spike_train = find(mea.spike_data{1})';
%% Compute Xcorr between LFP and spikes
iCorrelationWindow = 1*fs;
iTrialLength = fs*300;
[STA] = ComputeClassicSTA(iCorrelationWindow,iTrialLength,spike_train,low_x',0);
lags = [-iCorrelationWindow:iCorrelationWindow]./(fs/1e3);  %ms
set(gca,'fontsize',16)
%% Plot STA
plot(lags, STA)
ylabel('Amplitude (\muV)'), xlabel('Time lag (ms)')

%% Compute Xcorr between spikes and spikes
xcorrelogram = ComputeClassicCC_BB(iCorrelationWindow,iTrialLength,spike_train,spike_train,0);

%% fft of Xcorr1 and Xcorr2 and divide
L = length(STA);nfft = 2*L;
fft_STA = fft((STA+3e6)/L, nfft); 
% fft_STA = fft_STA(1:L/2+1); fft_STA(2:end) = 2*fft_STA(2:end);
fft_STA = fft_STA(1:L); fft_STA(2:end) = 2*fft_STA(2:end);
fft_xcorrelogram = fft(xcorrelogram/L, nfft);
% fft_xcorrelogram = fft_xcorrelogram(1:L/2+1); fft_xcorrelogram(2:end) = 2*fft_xcorrelogram(2:end);
fft_xcorrelogram = fft_xcorrelogram(1:L); fft_xcorrelogram(2:end) = 2*fft_xcorrelogram(2:end);
%ifft and visualize t he kernel
% kern = abs(ifft(fft_STA./fft_xcorrelogram));
% kern = deconv(STA, xcorrelogram);
kern = abs(ifft(fft_STA./fft_xcorrelogram));
plot((kern))
kern = abs(ifft(fft_STA./fft_xcorrelogram));
kern = ifft(fft(STA+3e6, nfft)./fft(xcorrelogram, nfft)).*sum(xcorrelogram);
skern = fftshift(kern(25e3+1:25e3+1+50e3));
STA_resampled = resample(STA,2,1);
kern_deconv = deconv(STA_resampled(1:end-1), xcorrelogram)/1e300;
plot(abs(kern_deconv))
%Convolve with spikes to get LFP

%Check anc compute pearson R


