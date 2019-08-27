
load filtered_mea_EC.mat
[space_average_r, r_data] = calculate_r_190703(mea_CA1, 1e3);
%%
%calculating time varying r-parameter
fs=mea_EC.par.down_fs;
time = 1:298; %s
                        figure(4)
subplot(211)
plot(time, space_average_r);
xlabel('Time (s)')
ylabel(' Kuramoto order')
ylim([0.02 0.06])
set(gca,'fontsize',16)
% title(' Time varying r-order with time bins = 1s')
subplot(212)
histogram(space_average_r,20);
xlabel(' Kuramoto order (r) (AU)')
ylabel('Count')
set(gca,'fontsize',16)
% title(' Histogram of r-order')
ylim([0 50])
xlim([0.025 0.06])
