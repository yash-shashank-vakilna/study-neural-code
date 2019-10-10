load ../data/'4ECDGCA3CA1 19914 160127 160303 d37 5minspont0001'/theta-mea/filtered_mea_tunnels.mat
%%
% mea.filtered_data = mea.filtered_data(25);
peakDuration = 500; refrTime = 500; multCoeff = 22;
[ peak_train_array ] = mea_detect_peaks_filtered_PTSD( mea, peakDuration, refrTime, multCoeff );
%%
chani=26; chanj=31;
fs = 25e3; ts = 1/fs:1/fs:300;
figure(1),clf
p(2)=subplot(211);
plot(ts, zscore(mea.filtered_data{chani}))
hold on
plot(ts, peak_train_array{chani})
hold off
p(1)=subplot(212);
plot(ts, zscore(mea.filtered_data{chanj}))
hold on
plot(ts, peak_train_array{chanj})
hold off
linkaxes(p,'x')