cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data\'
load dataInfo
fi =3;
cd(char("./"+fi+dataInfo.meaName{fi}))
meaNames = ["mea_EC","mea_DG","mea_CA3","mea_CA1","mea_tunnels"];
for regI = 1:length(meaNames)
    cd './raw-mea'
    rawMEA = load(meaNames(regI));
    cd ../spikes
    spikeMEA = load(meaNames(regI));
    fs = rawMEA.mea.par.fs; 
    for chani = 1:length(rawMEA.mea.channel_names)
        %%
        spikeSnippet = getSpikeSnippets...
            (spikeMEA.mea.spike_data{chani}, rawMEA.mea.raw_data{chani}, 1, fs);
        cd('C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\convolutionKernelLFP')
       %%
        for spiki = 509 %1:4:length(spikeSnippet)
            ts =0:1/25e3:2;
            if length(spikeSnippet{spiki}) < length(ts)
                continue;
            end
            subName = strrep(meaNames(regI),"mea_","");
            chanName = rawMEA.mea.channel_names{chani};
            x = spikeSnippet{spiki};
            x = zscore(double(x));
            fig=figure(1);plot(ts, x)
            til = "subregion-"+subName+" channel-" + chanName +" Spike number-"+ spiki;
            title(til)
            ylabel("Voltage (s.d.u)"), xlabel(' time (s)')
            set(gca,'FontSize',16)
            saveas(fig,char("./CWTresults/"+til),'png')
        end
    end
end
%%
x = spikeSnippet{spiki};
x = zscore(double(x));
[spikewaveform] = extract_spikes_from_spikecutouts(x, ts,1);
% plot(ts, spikewaveform)
[wt,f]=cwt(x,'amor',25e3);
e = calculates_energy_from_cwt(wt, f);
[wt_spike,f_spike]=cwt(spikewaveform,'amor',25e3);
e_spike = calculates_energy_from_cwt(wt_spike, f_spike);
percent_e = e_spike/e
%%
cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\convolutionKernelLFP\CWTresults\'
fig = computeCWTscalogram( x, subName, chanName, spiki,1, 1);
set(gca,'xlim',[0.8 1.2])
% saveas(gcf, 'DG-L3-653.png')
[spikewaveform] = extract_spikes_from_spikecutouts(x, ts);
fig = computeCWTscalogram( spikewaveform, subName, chanName, spiki,3);
set(gca,'xlim',[0.8 1.2])
tr_spikewaveform = translateANDcompute3spikes(spikewaveform, 40);

% saveas(gcf, 'DG-L3-653-spikes.png')
