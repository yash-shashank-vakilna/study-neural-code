cd '\\brewerserver\shared\Yash\SCA-spike-lfp-theta\spatio-temporal\S-T_T-T'
regList = {'EC','DG','CA3','CA1'};
meaTunnels = load('filtered_mea_tunnels');
meaTunnels = load('filtered_mea_tunnels');
for regI=1:4
    cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\ECDGCA3CA1_19908_160518_160610_d22_5minspont0001\theta_filtered
    %loading data and paramters
    meaSub = load(strcat('filtered_mea_',regList{regI}));
 
    for chanI=1:length(meaSub.mea.coordinates)
    %Source modellling 
        %find correspoonding tunnels
        [tunnelInd,tunnelCoord] = find_corresponding_tunnel(meaTunnels.mea,meaSub.mea, chanI, "S");
        %calculate phase synchrony
        ISPC_train = compute_ISPC(meaSub.mea.filtered_data{chanI},meaTunnels.mea.filtered_data{tunnelInd}, 1,meaSub.mea.par.down_fs, 1,0.2);
        STresult{regI}{1}{chanI,1} = meaSub.mea.channel_names{chanI};
        STresult{regI}{1}{chanI,2} = find_distance(meaSub.mea.coordinates{chanI}, tunnelCoord);
        STresult{regI}{1}{chanI,3} = mean(ISPC_train);
    %Target modellling 
        [tunnelInd,tunnelCoord] = find_corresponding_tunnel(meaTunnels.mea,meaSub.mea, chanI, "T");
        %calculate phase synchrony
        ISPC_train = compute_ISPC(meaSub.mea.filtered_data{chanI},meaTunnels.mea.filtered_data{tunnelInd}, 1,meaSub.mea.par.down_fs, 1,0.2);
        STresult{regI}{2}{chanI,1} = meaSub.mea.channel_names{chanI};
        STresult{regI}{2}{chanI,2} = find_distance(meaSub.mea.coordinates{chanI},tunnelCoord);
        STresult{regI}{2}{chanI,3} = mean(ISPC_train);
        disp("channels processed: "+chanI)
    end
    disp("reg: "+regI)
end
%% scatter and slop
figure(1)
cw_order = [1,2,4,3];
for regI = 1:4
    subplot(2,2,cw_order(regI))
    scatter(cell2mat(STresult{regI}{1}(:,2)).*0.2,cell2mat(STresult{regI}{1}(:,3)),'filled','blue')
    hold on
    scatter(cell2mat(STresult{regI}{2}(:,2)).*0.2,cell2mat(STresult{regI}{2}(:,3)),'filled','red')
    g=lsline;
    g(1).Color = 'b';
    g(2).Color = 'r';
    ylim([0.3 0.4]),xlim([0.2 1])
    xlabel('Distance (mm)'), 
    title(regList(regI))
    set(gca,'fontsize',16')
    hold off
end
legend('sounce -> tunnel','tunnel -> target')

%%
figure(2)
stdErr = @(x) std(x)/sqrt(length(x));
regList = ["EC>EC-DG>DG","DG>DG-CA3>CA3","CA3>CA3-CA1>CA1","CA1>CA1-EC>EC"];

S_mean = [ mean(cell2mat(STresult{1}{1}(:,3))),mean(cell2mat(STresult{2}{1}(:,3))),...
    mean(cell2mat(STresult{4}{1}(:,3))),mean(cell2mat(STresult{4}{1}(:,3)))];

S_Err = [ stdErr(cell2mat(STresult{1}{1}(:,3))),stdErr(cell2mat(STresult{2}{1}(:,3))),...
    stdErr(cell2mat(STresult{4}{1}(:,3))),stdErr(cell2mat(STresult{4}{1}(:,3)))];

T_mean = [ mean(cell2mat(STresult{1}{2}(:,3))),mean(cell2mat(STresult{2}{2}(:,3))),...
    mean(cell2mat(STresult{4}{2}(:,3))),mean(cell2mat(STresult{4}{2}(:,3)))];
T_err = [ stdErr(cell2mat(STresult{1}{2}(:,3))),stdErr(cell2mat(STresult{2}{2}(:,3))),...
    stdErr(cell2mat(STresult{4}{2}(:,3))),stdErr(cell2mat(STresult{4}{2}(:,3)))];

bar(0.8:3.8,S_mean,0.37)
hold on
errorbar(0.8:3.8,S_mean,S_Err,'.k')
bar(1.2:4.2,T_mean,0.37)
errorbar(1.2:4.2,T_mean,T_err,'.k')
xticks(1:4), xticklabels(regList(1:4))
legend('Source>Tunnel',  'SE','Tunnel>Target')
xlabel('Source -> Tunnels -> Target'), ylabel('Phase synchrony (ISPC (AU))')
set(gca,'FontSize',16,'XLim',[0.3 4.5])
hold off