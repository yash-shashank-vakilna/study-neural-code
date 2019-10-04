load ../data/'3ECDGCA3CA1 24574 160727 160818 d22 5minspont0001'/theta-mea/filtered_mea_tunnels.mat
%%
% mea.filtered_data = mea.filtered_data(25);
peakDuration = 500; refrTime = 500; multCoeff = 15;
[ peak_train_array ] = mea_detect_peaks_filtered_PTSD( mea, peakDuration, refrTime, multCoeff );
%%
chani=25;
fs = 25e3; ts = 1/fs:1/fs:300;
figure(1),clf
plot(ts, mea.filtered_data{1})
hold on
plot(ts, peak_train_array{1})
hold off