load ../data/'7ECDGCA3CA1 19914 150805 150828 d25 5minspont0001'/low-gamma-mea/filtered_mea_tunnels.mat 
%%
low_freq = 30; 
n=2;                                                                       %cycles in every piece
time_scale = round(n*1/low_freq*1e3); multCoeff = 16;
[ mea.filter_spike ] = mea_detect_peaks_filtered_PTSD( mea, time_scale, time_scale, multCoeff );
%% Cycle through the images and mark peaks
fs = 25e3;
ts = 1/fs:1/fs:300;
mkdir ./peakdetImage/'7'/
for chani=1:length(mea.filtered_data)
    figure(2)
    plot(ts, mea.filtered_data{chani})
    hold on
    plot(ts, mea.filter_spike{chani}.*10, 'r')
    ylabel(mea.channel_names{chani})
    hold off
    xlim([50 100])
    saveas(gcf, "./peakdetImage/7/"+mea.channel_names{chani}+".png")
end


%% Plot LFP and spikes
mea = ref_mea;
fs = 25e3;
ts = 1/fs:1/fs:300;
figure(2), clf
p(1)=subplot(211);
plot(ts, mea.filtered_data{25})
hold on
plot(ts, mea.filter_spike{25}.*10, 'r')
ylabel('F1')
hold off
grid on
p(2)=subplot(212);
plot(ts, mea.filtered_data{30})
hold on
plot(ts, mea.filter_spike{30}.*10, 'r')
ylabel('G1'); xlabel('Time (s)')
hold off
grid on
linkaxes(p, 'x')
xlabel('Time (s)')
%%
ts_seg = linspace(start_stop_matrix(1,1)./fs, start_stop_matrix(1,2)./fs, length(px_1));
figure;
p(1) = subplot(211);
plot(ts_seg, px_1)
ylabel('F1')
p(2) = subplot(212);
plot(ts_seg, px_2)
ylabel('G1'); xlabel('Time (s)')
linkaxes(p, 'x')