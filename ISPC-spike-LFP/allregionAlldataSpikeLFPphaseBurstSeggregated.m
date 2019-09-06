%% Seggregates burst and non-burst spikes and computes spike triggered phases for each set
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
fName= dir('*0001'); fName = string({fName(:).name});  
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];
nbins = 60; powerweight = 10;
%%
allregionresults={};
for fi=3:length(fName)
    cd(fName{fi})
    for regI = 1:5
        cd './spikes'
        spikeMEA = load(meaNames(regI));
        cd ../gamma-mea/
        filtMEA = load("filtered_"+meaNames(regI));
        fs = 25e3; 
        for chani = 1:length(filtMEA.mea.channel_names)
            [ burstAngleDistro,  nonburstAngleDistro] = computePhaseLockingSegBurst...
                (spikeMEA.mea.spike_data{chani}, filtMEA.mea.filtered_data{chani}, spikeMEA.mea.burst_data{chani});
            allregionresults{fi}{regI}{chani,1} = burstAngleDistro;
            allregionresults{fi}{regI}{chani,2} = nonburstAngleDistro;
            allregionresults{fi}{regI}{chani,3} = "burst and non-burst gamma phase values for for reg:" +regI+ " chani:"+filtMEA.mea.channel_names{chani};
            disp("processed fi:"+fi+ " regI:"+regI+" chani:"+chani)
        end
        cd('..')
    end
    cd('..')
end