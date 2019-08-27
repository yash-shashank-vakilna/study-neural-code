
regionList = {'EC','DG','CA3','CA1','tunnels'};
regN=1;

for reg = regionList
    cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\burstData'
    load(strcat('mea_',reg{1}))
    cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\STA\
    mkdir(strcat('./first-s-burst-resultFig/',reg{1},'/STA/'))
    mkdir(strcat('./first-s-burst-resultFig/',reg{1},'/pxx/'))
    fs = mea.par.fs;
    resultTable = {};
    %% Parameters for STA
    low_freq = 1; %Hz                                                   %lowest frequency for theta range                                                                        
    time_period = 0.25; %s
    iScaleWindow = 0.1*fs/low_freq; %sf-units
    iCorrelationWindow = time_period*fs; %sf-units
    iTrialLength = 5*60*fs;
    lag = -iCorrelationWindow/fs:1/fs:iCorrelationWindow/fs;
    for chanI = 1:length(mea.raw_data)
        %% Choosing data and perform STA
        resultTable{chanI,1} = mea.channel_names{chanI};
        %finding first spike in the burst 
        burst_data = mea.burst_data{chanI};
        first_spike_data = [0; diff(burst_data)];
        first_spike_data = find(first_spike_data > 0)';
        
        if isempty(first_spike_data)
            continue
        end
        lfp_data = double(mea.raw_data{chanI}');
        correlogram = run_SCA_binary_continuous_181203( iScaleWindow,iCorrelationWindow,iTrialLength,first_spike_data ,lfp_data );
        resultTable{chanI,2} = correlogram (1,:);
        %% Plot scaled STA
        figure(1)
        b=bar(lag,resultTable{chanI,2},'facecolor','flat');
        xlabel('Time (ms)')
        ylabel('Spike triggered average (\muV)')
        set(gca,'fontsize',18)
        saveas(gcf,strcat('./first-s-burst-resultFig/',reg{1},'/STA/',(resultTable{chanI,1}),'.png'))

        %% plot periodogram
        [pxx,f]=periodogram(correlogram(1,:),[], 1:0.1:140, 25e3,'power');
        resultTable{chanI,3} = pxx;
        figure(2)
        plot(f,pxx)
        xlabel('Frequency (Hz)')
        ylabel('Power (\muV^2)')    
        set(gca,'fontsize',16)
        saveas(gcf,strcat('./first-s-burst-resultFig/',reg{1},'/pxx/',(resultTable{chanI,1}),'.png'))
        disp(strcat('region:',reg{1},' channels processed: ', num2str(chanI)))

    end
    meaResultTable{regN,1}=reg;meaResultTable{regN,2}=resultTable;
    regN = regN + 1;
end