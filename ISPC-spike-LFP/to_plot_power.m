% Remove 0s in sr
for regi=1:4
    to_plot{regi}(to_plot{regi}(:,2) == 0,:) =[];
end

%%
tit = ["EC","DG","CA3","CA1"];
figno = [1,2,4,3];
figure(1)
for regi=1:4
    for fi= 3:7
        f_pos = to_plot{regi}(:,4) ==fi;
        p(regi)=subplot(2,2,figno(regi));
        scatter(to_plot{regi}(f_pos,1), to_plot{regi}(f_pos,2),'.')%,'o','filled')
        hold on
        title(tit(regi))
        xlabel('Power (\muV^2)')
        ylabel('Spike Rate (s^{-1})')
%         xlim([0.3 1400])
        set(gca,'XScale','log','FontSize',16)
    end
end
linkaxes(p,'xy')
hold off
legend({'ECDGCA3CA1 24574 160727 160818 d22 5minspont0001','ECDGCA3CA1 19914 160127 160303 d37 5minspont0001',...
    'ECDGCA3CA1 24088 160127 160302 d36 5minspont0001', 'ECDGCA3CA1 19908 150729 150823 d25 5minspont0001', 'ECDGCA3CA1 19914 150805 150828 d25 5minspont0001'})
%%  Plotting angle series example
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\2ECDGCA3CA1 19914 160127 160217 d21 5minspont0001\spikes'
spikeMEA = load('mea_tunnels');
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\2ECDGCA3CA1 19914 160127 160217 d21 5minspont0001\gamma-mea'
filtMEA = load('filtered_mea_tunnels.mat');
chani=1;
fs = 25e3;
ts = 1/fs:1/fs:300; ts = ts.*1e3;
p(1)=subplot(311);
plot(ts, spikeMEA.mea.raw_data{chani})
title('raw data for A6'), set(gca, 'FontSize',16)
p(2)=subplot(312);
plot(ts, filtMEA.mea.filtered_data{chani})
title('gamma filtered data'), set(gca, 'FontSize',16)
p(3)=subplot(313);
plot(ts, angle(hilbert(filtMEA.mea.filtered_data{chani})))
title('Angle series'), set(gca, 'FontSize',16)
linkaxes(p, 'x')
xlabel('Time (ms)')
%% Plotting power series example

cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\2ECDGCA3CA1 19914 160127 160217 d21 5minspont0001\spikes'
spikeMEA = load('mea_tunnels');
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\2ECDGCA3CA1 19914 160127 160217 d21 5minspont0001\gamma-mea'
filtMEA = load('filtered_mea_tunnels.mat');
power = computePower( filtMEA.mea.filtered_data{chani}, 1e3, 25e3);
SR = computeSpikeRate( spikeMEA.mea.spike_data{chani}, 1e3, 25e3);
chani=1;
fs = 25e3;
ts = 1/fs:1/fs:300; ts = ts.*1e3;
ts_chan = linspace(1,299,length(SR))*1e3;
p(1)=subplot(311);
plot(ts, spikeMEA.mea.raw_data{chani})
title('raw data for A6'), set(gca, 'FontSize',16)
p(2)=subplot(312);
plot(ts_chan,SR)
title('Spike rate'), set(gca, 'FontSize',16)
p(3)=subplot(313);
plot(ts_chan,power)
title('Power series'), set(gca, 'FontSize',16)
linkaxes(p, 'x')
xlabel('Time (ms)')