
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
fName= dir('*0001'); fName = string({fName(:).name});  
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];

% allregionresults = {};
for fi=5%3:length(fName)
    cd(fName{fi})
    allregionresults{fi} = {};
    for regI = 1:5
        
        cd './spikes'
        spikeMEA = load(meaNames(regI));
        cd ../theta-mea/
        filtMEA = load("filtered_"+meaNames(regI));
        fs = 25e3; 
        for chani = 1:length(filtMEA.mea.channel_names)
            p = zscore(computePower(filtMEA.mea.filtered_data{chani},(4/30)*1e3, 25e3));
            SR = computeSpikeRate(spikeMEA.mea.spike_data{chani},(4/30)*1e3, 25e3);
%             to_plot{regI} = [to_plot{regI}; [p',SR',repmat(chani, size(p))', repmat(fi, size(p))']];
            allregionresults{fi}{regI}{chani,1} = p';
            allregionresults{fi}{regI}{chani,2} = SR';
            allregionresults{fi}{regI}{chani,3} = "power and spike-rate theta for for reg:" +regI+ " chani:"+filtMEA.mea.channel_names{chani};
            disp("processed fi:"+fi+ " regI:"+regI+" chani:"+chani)
        end
        cd('..')
    end
    disp(fi+"processed")
    cd('..')
end