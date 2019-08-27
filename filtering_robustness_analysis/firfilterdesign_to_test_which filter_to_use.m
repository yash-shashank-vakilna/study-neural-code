load mea_EC
fs=25e3;

data = mea_EC.raw_data{1};
data = data(1:2*60*fs);
pts = length(data);
nbchan = 1;
times = [1:pts].*(1000/fs);

% specify Nyquist freuqency
nyquist = fs/2;

% filter frequency band theta
filtbound = [4 11]; % Hz

% transition width
trans_width = 0.2; % fraction of 1, thus 20%

% filter order
filt_order = round(1.5*(fs/filtbound(1)));

% frequency vector (as fraction of Nyquist
ffrequencies  = [ 0 (1-trans_width)*filtbound(1) filtbound (1+trans_width)*filtbound(2) nyquist ]/nyquist;

% shape of filter (must be the same number of elements as frequency vector
idealresponse = [ 0 0 1 1 0 0 ];

% get filter weights
% filterweights = firls(filt_order,ffrequencies,idealresponse);
filterweights = fir1(filt_order, [4 11]./nyquist);

% [~,filterweights] = eegfilt(data',fs,4,11);

% plot for visual inspection
figure(1), clf
subplot(211)
plot(ffrequencies*nyquist,idealresponse,'k--o','markerface','m')
set(gca,'ylim',[-.1 1.1],'xlim',[-2 nyquist+2])
xlabel('Frequencies (Hz)'), ylabel('Response amplitude')

subplot(212)
% plot((0:filt_order)*(1000/fs),filterweights)
plot((1:length(filterweights))*(1000/fs),filterweights)
xlabel('Time (ms)'), ylabel('Amplitude')
%%
% apply filter to data
filtered_data = zeros(nbchan,pts);
for chani=1:nbchan
    filtered_data(chani,:) = filtfilt(filterweights,1,double(data));
end

figure(2), clf
plot(times,squeeze(data))
hold on
plot(times,squeeze(filtered_data).*1e4,'r','linew',2)
xlabel('Time (ms)'), ylabel('Voltage (\muV)')
xlim([2e3 3e3])
legend({'raw data';'filtered'})