subMEA = load('../data/7ECDGCA3CA1 19914 150805 150828 d25 5minspont0001/theta-mea/filtered_mea_EC.mat');
tunnMEA = load('../data/7ECDGCA3CA1 19914 150805 150828 d25 5minspont0001/theta-mea/filtered_mea_tunnels.mat');
%%
subchani = find(contains(subMEA.mea.channel_names,'E3'));
tunnchani = find(contains(tunnMEA.mea.channel_names,'F3'));

fs=25e3; ts = 1/fs:1/fs:300;
p(1)=subplot(211);
plot(ts, subMEA.mea.filtered_data{subchani});
ylabel 'Theta band in Subregion'
set(gca,'fontsize',16)
p(2)=subplot(212);
plot(ts, tunnMEA.mea.filtered_data{tunnchani});
xlabel Times
ylabel 'Theta band in Tunnel'
set(gca,'fontsize',16)

linkaxes(p,'x')
xlim([155 160])