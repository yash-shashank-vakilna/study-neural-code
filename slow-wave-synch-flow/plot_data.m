%% Plot 
px_1 = x_1(ps:ps+n_scale-1);    
px_2 = x_2(ps:ps+n_scale-1);
ts = linspace(0, 0.5, length(px_1));
shift_s = -0.07864; px_1 = circshift(px_1, round(shift_s*fs)); 
figure(2)
p(1)=subplot(211);
plot(ts, px_1)
grid on
p(2)=subplot(212);
plot(ts, px_2)
grid on
linkaxes(p, 'x')
%%
figure(1)
[p, lags] = xcorr(px_1, px_2, maxlag);
stem(lags./25e3, p)
%% Plot 
ts = 1/fs:1/fs:300;
figure(3)
p(1)=subplot(211);
plot(ts, x_1)
grid on
p(2)=subplot(212);
plot(ts, x_2)
grid on
linkaxes(p, 'x')
%% Plot raw
filt_mea = load('../data/3ECDGCA3CA1 24574 160727 160818 d22 5minspont0001/theta-mea/filtered_mea_tunnels.mat');
% burst_mea = load('../data/3ECDGCA3CA1 24574 160727 160818 d22 5minspont0001/spikes/mea_tunnels.mat');
%%
ts = 1/fs:1/fs:300;
figure(2)
p(1)=subplot(211);
plot(ts, filt_mea.mea.filtered_data{25})
hold on
% plot(ts, burst_mea.mea.burst_data{25}.*100, 'r')
ylabel('F1')
hold off
grid on
p(2)=subplot(212);
plot(ts, filt_mea.mea.filtered_data{30})
hold on
% plot(ts, burst_mea.mea.burst_data{30}.*200, 'r')
ylabel('F1'); xlabel('Time (s)')
hold off
grid on
linkaxes(p, 'x')
xlabel('Time (s)')