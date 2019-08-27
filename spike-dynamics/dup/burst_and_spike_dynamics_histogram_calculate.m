cd \\brewerserver\shared\Yash\SCA-spike-lfp-theta\data
folderNames = dir('*0001'); folderNames = {folderNames(1:end).name};
meaNames = {'mea_EC','mea_DG','mea_CA3','mea_CA1','mea_tunnels'};
minSpikes = 4;ISImax = 50;min_mbr = 0.4;
fs = 25e3;
allfolderRegion =cell(1,4);
for regI = 1:4
    % initialising regionwise 
    % regionwise contains from all the folders
    singleRegionResult.SR = []; singleRegionResult.ISI = []; singleRegionResult.BD={}; 
    singleRegionResult.spnb = []; singleRegionResult.IBSR = {}; singleRegionResult.IBI=[];
        
    for meaI = [1 2 5 6 7]
        cd(folderNames{meaI}+"\spikes")
        load(meaNames{regI})
        meaBD =[]; meaIBSR=[];
        for chani = 1:length(mea.spike_data)
            % Loading Spike data
            spikeData = mea.spike_data{chani};
            nspikes = length(find(spikeData));
            ISI = diff(find(spikeData)./25e3);
            
            % Detecting Burst spikes
            [ burst_detection,  ~, ~] = detectBurst_singleChannel_190409( spikeData, minSpikes, ISImax, min_mbr );
            if size(burst_detection,1) < 2 || isempty(burst_detection)
                disp("skipping channels: " + chani)
                continue;
            end
            
            bd_sec = burst_detection(:,4);
            ibi_sec = burst_detection(:,6);
            spnb = burst_detection(:,3);
            IBSR = spnb./bd_sec;
            disp("processed channels: "+chani)
            
            %saving in a regionwise result
            singleRegionResult.SR = [singleRegionResult.SR; nspikes./(length(spikeData)/fs)];
            singleRegionResult.ISI = [singleRegionResult.ISI; ISI];
            meaBD = [meaBD; bd_sec];
            meaIBSR = [meaIBSR; IBSR];
            singleRegionResult.spnb = [singleRegionResult.spnb; spnb];
            singleRegionResult.IBI = [singleRegionResult.IBI; ibi_sec];
        
        end
        singleRegionResult.IBSR{meaI} = meaIBSR;
        singleRegionResult.BD{meaI} = meaBD;
        disp("processed folder: " + folderNames(meaI))
        cd ../..
    end
    allfolderRegion{regI} = singleRegionResult;
end