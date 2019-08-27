freq_ranges = [1 4; 4 11; 11 30; 30 140];
load freq;
regAv = {};
for regI = 1:5
    %%
    freqdata = [];
    for chanI = 1:size(meaResultTable{regI,2},1)-1
        if isempty(meaResultTable{regI,2}{chanI,2})
            continue
        end
        len_STA = length(meaResultTable{regI,2}{chanI,2});
        STAdata(1,:) = meaResultTable{regI,2}{chanI,2}(1:(len_STA-1)/2);        %Pre-spike 
        STAdata(2,:) = meaResultTable{regI,2}{chanI,2}((len_STA+3)/2:len_STA);  %Post-spike
        PSDdata(1,:) = periodogram(STAdata(1,:),[], 1:0.1:140, 25e3,'power');
        [PSDdata(2,:),f] = periodogram(STAdata(2,:),[], 1:0.1:140, 25e3,'power');
        
        for fi = 1:4
            ind  = f > freq_ranges(fi,1) & f < freq_ranges(fi,2);
            freqdata(chanI,fi,1) = sum(PSDdata(1,ind))/(freq_ranges(fi,2) - freq_ranges(fi,1));
            freqdata(chanI,fi,2) = sum(PSDdata(2,ind))/(freq_ranges(fi,2) - freq_ranges(fi,1));
        end
    end
     %%
     for fi = 1:4
        freqAvStd(fi,1) = mean(freqdata(freqdata(:,fi,1)>0,fi,1));
        freqAvStd(fi,2) = std(freqdata(freqdata(:,fi,1)>0,fi,1))/length(freqdata(freqdata(:,fi,1)>0,fi,1));
        freqAvStd(fi,3) = mean(freqdata(freqdata(:,fi,2)>0,fi,2));
        freqAvStd(fi,4) = std(freqdata(freqdata(:,fi,2)>0,fi,2))/length(freqdata(freqdata(:,fi,2)>0,fi,2));
     end
    
    meafreqAvStd{regI} = freqAvStd;   %%
end
%% Plot Bars
freqName = {'\delta','\theta','\beta','\gamma'};
regNames = {'EC','DG','CA3','CA1','tunnels'};
for regI = 1:length(meafreqAvStd)
    figure(regI)
    b1=bar(1:4, meafreqAvStd{regI}(:,1),0.2);
%     set(gca, 'YScale','log')
    hold on
    errorbar(1:4, meafreqAvStd{regI}(:,1), meafreqAvStd{regI}(:,2),'.')
    b2=bar(1.2:4.2, meafreqAvStd{regI}(:,3),0.2,'r');
%     set(gca, 'YScale','log')
    errorbar(1.2:4.2, meafreqAvStd{regI}(:,3), meafreqAvStd{regI}(:,4),'.')
    xticklabels(freqName)
    title(regNames{regI})
    legend([b1,b2],{'Before spikes', 'After spikes'})
    xlabel('Frequency bands'); ylabel('Band power');
    hold off
    saveas(gcf,regNames{regI},'fig')
    
end
    
