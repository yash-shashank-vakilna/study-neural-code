cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\7ECDGCA3CA1 19914 150805 150828 d25 5minspont0001'\
spikeMEA = load('./spikes/mea_EC.mat');
filtMEA = load('./theta-mea/filtered_mea_EC.mat');
fs=25e3;

%%
chani=6;
ts = 1/fs:1/fs:300;
figure(1)
p(1)=subplot(311);
plot(ts, spikeMEA.mea.raw_data{chani})
title('raw data for C2');ylabel('Amplitude (\muV)')
set(gca, 'FontSize', 16)
p(2)=subplot(312);
plot(ts, filtMEA.mea.filtered_data{chani})
title('theta filtered data for C2'); ylabel('Amplitude (\muV)')
set(gca, 'FontSize', 16)
p(3)=subplot(313);
plot(ts, circ_rad2ang(angle(hilbert(filtMEA.mea.filtered_data{chani}))))
xlabel('Time (s)')
ylabel('Phase (degree)')
title('angle series')
set(gca, 'FontSize', 16)
linkaxes(p,'x')