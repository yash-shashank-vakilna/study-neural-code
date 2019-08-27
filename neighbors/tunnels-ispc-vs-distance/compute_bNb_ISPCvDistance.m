% tunnelMea = load('\\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\burstData\mea_tunnels.mat');
burstCell = tunnelMea .mea.burst_data;
no_chan = length(burstCell);
% clear burstMea
for chanI = 1:no_chan
    burstCell{chanI} = burstCell{chanI}(25e3:end-25e3-1);
end
filterCell = tunnelMea.mea.filtered_data;
for chanI = 1:no_chan
    filterCell{chanI} = resample(filterCell{chanI},250,1);
end
chanList = tunnelMea.mea.channel_names;
coordList = tunnelMea.mea.coordinates;
%initialize paramters
no_chan = length(burstCell);
tunnelSets = {[2:2:10], [40:44], [15:2:24], 25:29};
tunResults = cell(1,4);
%% Processing Data
for tunI = 1:length(tunnelSets)
    tunN = 1;
    for refI = 1:length(tunnelSets{tunI})
        for tarJ = refI+1:length(tunnelSets{tunI})
            %seggregate burst/non-burst
            
            both_burst = burstCell{tunnelSets{tunI}(refI)} & burstCell{tunnelSets{tunI}(tarJ)};
            burst_data= [double(filterCell{(tunnelSets{tunI}(refI))}(both_burst))';...
                double(filterCell{tunnelSets{tunI}(tarJ)}(both_burst))'];
            non_burst_data = [double(filterCell{(tunnelSets{tunI}(refI))}(not(both_burst)))';...
                double(filterCell{tunnelSets{tunI}(tarJ)}(not(both_burst)))'];
            %annotating results
            tunResults{tunI}{1}{tunN,1} = "burst-"+string(chanList{tunnelSets{tunI}(refI)})+"-"+string(chanList{tunnelSets{tunI}(tarJ)});
            tunResults{tunI}{2}{tunN,1} = "non-burst-"+string(chanList{tunnelSets{tunI}(refI)})+"-"+string(chanList{tunnelSets{tunI}(tarJ)});
            %coupute ISPC of burst/non-burst
            tunResults{tunI}{1}{tunN,2} = mean(compute_ISPC(burst_data(1,:)',burst_data(2,:)', 1,25e3, 1,0));
            tunResults{tunI}{2}{tunN,2} = mean(compute_ISPC(non_burst_data(1,:)',non_burst_data(2,:)', 1,25e3, 1,0));
            %finding distance
            tunResults{tunI}{1}{tunN,3} = find_distance(coordList{tunnelSets{tunI}(refI)} , coordList{tunnelSets{tunI}(tarJ)});
            tunResults{tunI}{2}{tunN,3} = find_distance(coordList{tunnelSets{tunI}(refI)} , coordList{tunnelSets{tunI}(tarJ)});
            
            disp("processed ref channel no: "+tunN)
            tunN = tunN+1;
        end
    end
end
%% scatter and slop
regList = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
figure(1)
clf
cw_order = [1,2,4,3];
for regI = 1:4
    ax(regI)=subplot(2,2,cw_order(regI))
    scatter(cell2mat(tunResults{regI}{1}(:,3)).*0.2,cell2mat(tunResults{regI}{1}(:,2)),'filled','blue')
    hold on
    scatter(cell2mat(tunResults{regI}{2}(:,3)).*0.2,cell2mat(tunResults{regI}{2}(:,2)),'filled','red')
    g=lsline;
    g(1).Color = 'r';
    g(2).Color = 'b';
    xlabel('Distance (mm)'), 
    title(regList(regI))
    set(gca,'fontsize',16')
    hold off
end
linkaxes(ax,'xy')
legend('Burst','Non-burst')
