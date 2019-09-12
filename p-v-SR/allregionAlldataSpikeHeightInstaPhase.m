
%%
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
fName= dir('*0001'); fName = string({fName(:).name});  
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];
allregionresults=cell(1,4);
no_features = 2;                                                             % change the no of features 
%%
for fi=3:length(fName)
    %% Looping through mea recordings
    cd(fName{fi})
    allregionresults{fi} = cell(1,5); 
    for regI = 1:5
        %% Looping through subregions
        cd './spikes'
        spikeMEA = load(meaNames(regI));
        cd ../theta-mea/
        filtMEA = load("filtered_"+meaNames(regI));
        fs = 25e3; 
        if regI < 4
            allregionresults{fi}{regI} = cell(19,no_features+1);
        else
            allregionresults{fi}{regI} = cell(44,no_features+1);
        end
        for chani = 1:length(filtMEA.mea.channel_names)
            %% Compute channelwise metric
            if ~(isempty(spikeMEA.mea.spike_data{chani}))
                [ spikeHeight,~, spike_triggered_insta_phase] = computeSpikeheightvsPower...          %compute spike height and spike triggered 
                    (spikeMEA.mea.spike_data{chani}, zscore(filtMEA.mea.filtered_data{chani}));
                allregionresults{fi}{regI}{chani,1} = spikeHeight;
                allregionresults{fi}{regI}{chani,2} = spike_triggered_insta_phase;                  %spike triggered magnitude instantaneous power
                allregionresults{fi}{regI}{chani,3} = ...
                    "Spike height and Spike triggered instantaneous power of fi:"...
                    +fi+ " regI:"+regI+" chani:"+chani ;
            end
            disp("processed fi:"+fi+ " regI:"+regI+" chani:"+chani)
        end
        cd('..')
    end
    cd('..')
end