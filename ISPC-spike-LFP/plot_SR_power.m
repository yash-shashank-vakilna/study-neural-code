cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\7ECDGCA3CA1 19914 150805 150828 d25 5minspont0001'\
regI=2;
regName = ["mea_EC","mea_DG","mea_CA1","mea_CA3","mea_tunnels"];
spikeMEA = load('./spikes/'+regName(regI));
filtMEA = load('./gamma-mea/filtered_'+regName(regI));
fs=25e3;

%%
chani=11;
t_scale = 4/3*1e3;
power = computePower(filtMEA.mea.filtered_data{chani},t_scale, 25e3);
[SR, t] = computeSpikeRate(spikeMEA.mea.spike_data{chani},t_scale, 25e3);

ts = 1/fs:1/fs:300;
ts_series = linspace(t_scale/1e3,300, length(SR));
figure(1)
p(1)=subplot(311);
plot(ts, spikeMEA.mea.raw_data{chani})
title(strcat('Raw data-',spikeMEA.mea.channel_names{chani}));ylabel('Amplitude (\muV)')
set(gca, 'FontSize', 16)
p(2)=subplot(312);
plot(ts_series, SR)
title('Spike rate'); 
ylabel('Spike Rate (s^{-1})')
set(gca, 'FontSize', 16)
p(3)=subplot(313);
plot(ts_series, power)
xlabel('Time (s)')
ylabel('Power (\muV^2)')
title('Power series')
set(gca, 'FontSize', 16)
linkaxes(p,'x')