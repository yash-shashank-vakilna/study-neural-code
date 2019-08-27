%% Load burst/non-burst data and theta data
cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001'
regList = ["EC","DG","CA3","CA1","tunnels"];
for regI=1
% for regI = 5
    
    filterMea = load("./theta_filtered/filtered_mea_"+regList(regI)+".mat");
    filterCell = filterMea.mea.filtered_data;
    no_chan = length(filterCell);
    for chanI = 1:no_chan
        filterCell{chanI} = resample(filterCell{chanI},250,1);
    end
    clear filterMea
    %initialize paramters
    
    colorMapMat = zeros(no_chan);
    
    %% Processing Data
    for refI = 1:no_chan
        for tarJ = refI:no_chan
            %coupute ISPC of burst/non-burst
            ISPC_train = compute_ISPC(filterCell{refI}, filterCell{tarJ}, 1,25e3, 1,0.2);
            %create colormap of coherence  
            colorMapMat(refI,tarJ) = mean(ISPC_train); 
        end
    end

%save in Result array
colormapResults{regI,1} = regList{regI}+"-all";
colormapResults{regI,2} = colorMapMat; 
end
%% Find distances 
cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001'
cartDist = @(x,y) sqrt((x(1)-y(1)).^2 + (x(2)-y(2)).^2);
regList = ["EC","DG","CA3","CA1","tunnels"];
for regI=1:5
    filterMea = load("./theta_filtered/filtered_mea_"+regList(regI)+".mat");
    distCell = filterMea.mea.coordinates;
    no_chan = length(distCell);
    
    %initialize paramters
    distList = zeros(no_chan);
    for refI = 1:no_chan
        for tarJ = refI:no_chan
            %distance 
             distList(refI,tarJ) = cartDist(distCell{refI}, distCell{tarJ})*0.2; 
        end
    end

    %save in Result array
    distmapResults{regI,1} = regList{regI}+"-dist";
    distmapResults{regI,2} = distList; 
end

%% Plot colormap

cw_order = [1,2,4,3];
for regI=1:4
    figure(regI)
    cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001'
    filterMea = load("./theta_filtered/filtered_mea_"+regList(regI)+".mat");
    imagesc(colormapResults{regI,2},[0.3 0.5])
    colorbar, colormap('jet')
    xticks(1:19); xticklabels(filterMea.mea.channel_names);
    yticks(1:19); yticklabels(filterMea.mea.channel_names);
    axis square
    title(regList{regI})
    cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\spatio-temporal\channel-colormap\output'
    saveas(gcf,regList(regI)+"_channel.png")
end
%% Plot Bargraph
regList = ["EC","DG","CA3","CA1","tunnels"];
figure(1)
for subI = 1:4
    channelCell{subI} = reshape(triu(colormapResults{subI,2},1),1,[]);
    channelCell{subI} = channelCell{subI}(channelCell{subI} > 0);
end
figure
bar([mean(channelCell{1}),mean(channelCell{2}),mean(channelCell{3}),mean(channelCell{4})])
hold on
errorbar(1:4,[mean(channelCell{1}),mean(channelCell{2}),mean(channelCell{3}),mean(channelCell{4})],...
    [std(channelCell{1})/sqrt(length(channelCell{1})),std(channelCell{2})/sqrt(length(channelCell{2})), std(channelCell{3})/sqrt(length(channelCell{3})), std(channelCell{4})/sqrt(length(channelCell{4}))],'.r')
xticklabels(regList(1:4))
set(gca,'FontSize',16)
xlabel('sub-region');ylabel('Phase Synchrony (ISPC (AU))');
saveas(gcf, 'ISPCvsSubregion.png')
%% Perform ANOVA
anovaResult = (cell2mat(channelCell'))';
[p,t,stats] = anova1(anovaResult);
[c,m,h,nms] = multcompare(stats);
%% synchrony wrt distance 
col = {'b','r','g','m'}; cw_order = [1,2,4,3];
figure(1)
for subI = 1:4
    ax(subI)=subplot(2,2,cw_order(subI));
    scatter((convert2vec(distmapResults{subI, 2})), convert2vec(colormapResults{subI, 2}),'filled',col{subI})    
    h = refline;
    h.Color = col{subI};
    title(regList{subI})
    xlabel('Distance (mm)'); ylabel('Phase synchrony (ISPC(AU))');
    set(gca,'fontsize',16)
    
end
linkaxes(ax,'xy')

hold off

