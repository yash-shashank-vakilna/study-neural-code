
%%
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
fName= dir('*0001'); fName = string({fName(:).name});  
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];
% allregionresults={};
for fi=3:length(fName)
    cd(fName{fi})
    for regI = 1:5
        cd './spikes'
        spikeMEA = load(meaNames(regI));
        cd ../gamma-mea/
        filtMEA = load("filtered_"+meaNames(regI));
        fs = 25e3; 
        for chani = 1:length(filtMEA.mea.channel_names)
            [meanV, weight_angle_distro, angle_distro] = computeWeightedPhaseLocking(spikeMEA.mea.spike_data{chani}, filtMEA.mea.filtered_data{chani});
            allregionresults{fi}{regI}{chani,1} = meanV;
            allregionresults{fi}{regI}{chani,2} = weight_angle_distro;
            allregionresults{fi}{regI}{chani,3} = angle_distro;
            allregionresults{fi}{regI}{chani,4} = "Phase-locking angle for reg:" +regI+ " chani:"+filtMEA.mea.channel_names{chani};
            disp("processed fi:"+fi+ " regI:"+regI+" chani:"+chani)
        end
        cd('..')
    end
    cd('..')
end