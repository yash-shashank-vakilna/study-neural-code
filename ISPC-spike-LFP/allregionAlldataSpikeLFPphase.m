
%%
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'
fName= dir('*0001'); fName = string({fName(:).name});  
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];
allregionresults=struct;
allregionresults.weighted_phase = {};
time_period = 1e3;
for fi=3:length(fName)
    cd(fName{fi})
    for regI = 5
        cd './spikes'
        spikeMEA = load(meaNames(regI));
        cd ../gamma-mea/
        filtMEA = load("filtered_"+meaNames(regI));
        fs = 25e3; 
        for chani = 1:length(filtMEA.mea.channel_names)
            [meanV, angle_distro] = computePhaseLocking(spikeMEA.mea.spike_data{chani}, filtMEA.mea.filtered_data{chani});
            allregionresults.weighted_phase{fi}{regI}{chani} = angle_distro;
            disp("processed fi:"+fi+ " regI:"+regI+" chani:"+chani)
        end
        cd('..')
    end
    cd('..')
end