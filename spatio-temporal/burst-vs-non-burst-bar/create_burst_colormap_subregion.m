%% Load burst/non-burst data and theta data
cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001'
regList = ["EC","DG","CA3","CA1","tunnels"];

for regI = 1:5
    burstMea = load("./burstData/mea_"+regList(regI)+".mat");
    burstCell = burstMea.mea.burst_data;
    no_chan = length(burstCell);
    % clear burstMea
    for chanI = 1:no_chan
        burstCell{chanI} = burstCell{chanI}(25e3:end-25e3-1);
    end
    filterMea = load("./theta_filtered/filtered_mea_"+regList(regI)+".mat");
    filterCell = filterMea.mea.filtered_data;
    for chanI = 1:no_chan
        filterCell{chanI} = resample(filterCell{chanI},250,1);
    end
    clear filterMea
    %initialize paramters
    no_chan = length(burstCell);
    burstColor = zeros(no_chan);
    nonBurstColor = burstColor;
    %% Processing Data
    for refI = 1:no_chan
        for tarJ = refI:no_chan
            %seggregate burst/non-burst
            both_burst = burstCell{refI} & burstCell{tarJ};
            burst_data= [double(filterCell{(refI)}(both_burst))';...
                double(filterCell{(tarJ)}(both_burst))'];
            non_burst_data = [double(filterCell{(refI)}(not(both_burst)))';...
                double(filterCell{(tarJ)}(not(both_burst)))'];
            %coupute ISPC of burst/non-burst
            burst_ISPC_train = compute_ISPC(burst_data(1,:)',burst_data(2,:)', 1,25e3, 1,0);
            non_burst_ISPC_train = compute_ISPC(non_burst_data(1,:)',non_burst_data(2,:)', 1,25e3, 1,0);
            %create colormap of coherence  
            burstColor(refI,tarJ) = mean(burst_ISPC_train); 
            nonBurstColor(refI,tarJ) = mean(non_burst_ISPC_train); 
        end
    end

%save in Result array
colormapResults{regI,1} = regList{regI}+"-burst/non-burst";
colormapResults{regI,2} = burstColor; colormapResults{regI,3}=nonBurstColor;
disp("processed ref channel no: "+refI)
end
%% Plot colormap

for subI = 1:4
    data = reshape(triu(colormapResults{subI,2},1),[],1);
    if isempty(data)
        channelCell{subI,1} = 0;
    else
        if isempty(data > 0)
            channelCell{subI,1} = 0;
        else
            channelCell{subI,1} = data(data > 0);
        end
    end
end

for subI = 1:4
    data = reshape(triu(colormapResults{subI,3},1),[],1);
    if isempty(data)
        channelCell{subI,2} = 0;
    else
        if isempty(data > 0)
            channelCell{subI,2} = 0;
        else
            channelCell{subI,2} = data(data > 0);
        end
    end
end
%% Plot Bar
stdErr = @(x) std(x)/sqrt(length(x));
regList = ["EC","DG","CA3","CA1","tunnels"];
bar(0.8:3.8,[0 mean(channelCell{2,1}) mean(channelCell{3,1}) mean(channelCell{4,1})],0.37)
hold on
errorbar(0.8:3.8,[0 mean(channelCell{2,1}) mean(channelCell{3,1}) mean(channelCell{4,1})],...
    [0 stdErr(channelCell{2,1}) stdErr(channelCell{3,1}) stdErr(channelCell{4,1})],'.r')
bar(1.2:4.2,[mean(channelCell{1,2}) mean(channelCell{2,2}) mean(channelCell{3,2}) mean(channelCell{4,2})],0.37)
errorbar(1.2:4.2,[mean(channelCell{1,2}) mean(channelCell{2,2}) mean(channelCell{3,2}) mean(channelCell{4,2})],...
    [stdErr(channelCell{1,2}) stdErr(channelCell{2,2}) stdErr(channelCell{3,2}) stdErr(channelCell{4,2})],'.r')
xticks(1:4), xticklabels(regList(1:4))
legend('Burst',  'SE','Non-burst')
xlabel('Sub-regions'), ylabel('Phase synchrony (ISPC (AU))')
set(gca,'FontSize',16,'XLim',[0.5 4.5])
%%
anova1([channelCell{2,1}, channelCell{2,2}'], ['burst', repmat({'non-burst'},1,length(channelCell{2,2}))])
i=3;anova1([channelCell{i,1}', channelCell{i,2}'], [repmat({'burst'},1,length(channelCell{i,1})), repmat({'non-burst'},1,length(channelCell{i,2}))]);
i=4;anova1([channelCell{i,1}', channelCell{i,2}'], [repmat({'burst'},1,length(channelCell{i,1})), repmat({'non-burst'},1,length(channelCell{i,2}))]);