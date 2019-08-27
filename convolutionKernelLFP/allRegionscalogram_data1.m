cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\2ECDGCA3CA1 19914 160127 160217 d21 5minspont0001'
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];
for regI = 2%1:length(meaNames)
    cd './raw-mea'
    spikeMEA = load(meaNames(regI));
    cd ../spikes
    rawMEA = load(meaNames(regI));
    fs = rawMEA.mea.par.fs; 
    for chani = 15 %2:length(rawMEA.mea.channel_names)
        spikeSnippet = getSpikeSnippets(spikeMEA.mea.spike_data{chani}, rawMEA.mea.raw_data{chani}, 1, fs);
        %%
        for spiki = 653 %1:4:length(spikeSnippet)
            ts =0:1/25e3:2;
            if length(spikeSnippet{spiki}) < length(ts)
                continue;
            end
            subName = strrep(meaNames(regI),"mea_","");
            chanName = rawMEA.mea.channel_names{chani};
%             fig = computeCWTscalogram( spikeSnippet{spiki}, subName, chanName, spiki);
            x = spikeSnippet{spiki};
            x = zscore(double(x));
            fig=figure(1);plot(ts, x)
            title("subregion:"+subName+" channel:" + chanName +" Spike number:"+ spiki)
            ylabel("Voltage (s.d.u)")
            saveFolder = "C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\convolutionKernelLFP\CWTresults\2\folder-spike-cutouts\";
            figtitle = subName+"_"+chanName+"_"+spiki;
%             saveas(fig, char(saveFolder+figtitle+".fig"))
            saveas(fig, char(saveFolder+figtitle+".png"))
        end
    end
    cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\1ECDGCA3CA1 19908 160518 160610 d22 5minspont0001'
end