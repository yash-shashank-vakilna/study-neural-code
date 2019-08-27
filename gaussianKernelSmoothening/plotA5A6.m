fs = 25e3;
ts = 1/fs:1/fs:300;
figure(2)
p(1) = subplot(411);
plot(ts, mea.raw_data{2})
ylabel('A5-raw (mv)'), set(gca,'FontSize', 16)
p(2) = subplot(412);
plot(ts, mea.filtered_data{2})
ylabel('A5-theta (mv)'), set(gca,'FontSize', 16)
p(3) = subplot(413);
plot(ts, tunnelMea.mea.raw_data{1})
ylabel('A6-raw'), set(gca,'FontSize', 16)
data=gaussianKernelMoving(tunnelMea.mea.spike_data{1}, gaussWidth, fs);
p(4) = subplot(414);
plot(ts, data)
ylabel('A6-Gaussian-smooth-spikes'), set(gca,'FontSize', 16)
linkaxes(p,'x')
xlabel(' Time (s)')
%%
maxLags = cell2mat(allChannelResults(:,3));
histogram(maxLags, 200), xlim([ -100 100])
xlabel('maxLags (ms)'), ylabel('Count')
set(gca, 'fontsize',16)
saveas(gca, 'histogram-maxlags.png')