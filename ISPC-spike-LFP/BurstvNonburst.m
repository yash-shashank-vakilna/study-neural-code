cd('C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001')
cd('./spikes/')
spikeMEA = load('./mea_tunnels');
cd('../theta-mea')
filtMEA = load('./filtered_mea_tunnels');
%%
all_burst=[]; all_non_burst=[];
for chani=1:44
    burstData = spikeMEA.mea.burst_data{chani};
    spikeData = sign(spikeMEA.mea.spike_data{chani});
    LFPdata = filtMEA.mea.filtered_data{chani};
    angleS = angle(hilbert(LFPdata));
    total_phase_lag = spikeData.*angleS;

    burst_angleS = total_phase_lag(burstData);
    non_burst_angleS = total_phase_lag(not(burstData));

    burst_angleS( burst_angleS==0) = [];
    non_burst_angleS( non_burst_angleS==0) = [];

    tit = "Channel= "+chani+"-"+filtMEA.mea.channel_names{ chani};
    figure(1)
    subplot(121),polarhistogram(burst_angleS,125), title('Burst Data')
    subplot(122),polarhistogram(non_burst_angleS,125), title('Non burst Data')
    title(tit)
    saveas(gcf, char(tit),'png')
    
    all_burst = [all_burst; burst_angleS]; 
    all_non_burst = [all_non_burst; non_burst_angleS]; 
end
%%

figure(2), clf
subplot(121),polarhistogram(all_burst, 150), title('Burst Data')
hold on
angleS = angle(mean(exp(1i*all_burst)));
polarplot([angleS angleS],[0 3000],'r','linewidth',2)
hold off
subplot(122),polarhistogram(all_non_burst, 150)
hold on
angleS = angle(mean(exp(1i*all_non_burst)));
polarplot([angleS angleS],[0 500],'r','linewidth',2), title('Non-burst Data')
hold off