% Detect peak
load ../data/'3ECDGCA3CA1 24574 160727 160818 d22 5minspont0001'/theta-mea/filtered_mea_tunnels.mat
%%
% mea.filtered_data = mea.filtered_data(25);
peakDuration = 500; refrTime = 500; multCoeff = 20;
[ mea.filter_spike ] = mea_detect_peaks_filtered_PTSD( mea, peakDuration, refrTime, multCoeff );

%% Extract time start stops of the segments

low_freq = 4; time_scale = n*1/low_freq; overlap = 0.5; if_zscore = 1;
chani = 25; chanj = 30; 
start_stop_matrix = extract_start_stop_using_peak_train(mea.filtered_data{chani},...
    mea.filtered_data{chanj}, peak_train_array{chani}, peak_train_array{chanj}, time_scale);