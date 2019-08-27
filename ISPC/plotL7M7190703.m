figure(1), clf
ts=1/25e3:1/25e3:300; 
[ISPC,tspc] = compute_ISPC(mea.filtered_data{22},mea.filtered_data{24}, 1,25e3,1, 0);
p(1)=subplot(511);
plot(ts, mea.raw_data{22}), ylabel('raw L7')
hold on
spikeData = (find(mea.spike_data{22}))./25e3;
scatter(spikeData, repmat(-1.5e4, length(spikeData), 1),'.r')
hold off
set(gca,'FontSize',12)
p(2) = subplot(512);
plot(ts, mea.filtered_data{22}), ylabel('theta L7')
set(gca,'FontSize',12)
p(3) = subplot(513);
plot(ts, mea.raw_data{24}), ylabel('raw M7')
hold on
spikeData = (find(mea.spike_data{24}))./25e3;
scatter(spikeData, repmat(-2.5e3, length(spikeData), 1),'.r')
hold off
set(gca,'FontSize',12)
p(4) = subplot(514);
plot(ts, mea.filtered_data{24}), ylabel('theta M7')
set(gca,'FontSize',12)
p(5) = subplot(515);
plot(tspc, ISPC), ylabel('Phase synchrony'), xlabel('Time (s)')
set(gca,'FontSize',12)
linkaxes(p,'x')

