cd 'C:\Users\yashv\Desktop\Yash\File Sync(1)\Yash\SCA-spike-lfp-theta\data'

fs=25e3;
iScaleSegmentSize = 250*fs/1e3; %sf-units                                               %lower bound theta freq = 4Hz
iCorrelationWindow = 1e3*fs/1e3; %sf-units
iTrialLength = 5*60*fs;
folderWiseResult = cell(1,4);

folderAddr = dir('*0001'); 
folderAddr = {folderAddr.name};
for fi = 2:length(folderAddr)
    cd(folderAddr{fi}+"\spikes")
    meaAddr = {'mea_EC','mea_DG','mea_CA3','mea_CA1','mea_tunnels'};
    folderWiseResult{fi} = cell(1,5);
    for regI = 1:length(meaAddr)
        load(meaAddr{regI})
        if regI== 5
            %processing tunnels
            tunnelsSetName = ["EC-DG","DG-CA3","CA3-CA1","CA1-EC"];
            for tunnelI = 1:length(tunnelsSetName)
                tunnelSetI = strcmpi(mea.subregion,(tunnelsSetName(tunnelI)));
                tunnelMea = mea;
                tunnelMea.spike_data = tunnelMea.spike_data(tunnelSetI);
                tunnelMea.subregion = tunnelMea.subregion(tunnelSetI);
                tunnelMea.coordinates = tunnelMea.coordinates(tunnelSetI);
                [CorrConnectivityMatrix,LagConnectivitymatrix] = computeXcorrConnectivityMatrice...
                (tunnelMea, iScaleSegmentSize, iCorrelationWindow, iTrialLength, fs);
                folderWiseResult{fi}{tunnelI,2}{1} = CorrConnectivityMatrix;
                folderWiseResult{fi}{tunnelI,2}{2} = LagConnectivitymatrix;
            end
            
        else
            %processing subregions
            [CorrConnectivityMatrix,LagConnectivitymatrix] = computeXcorrConnectivityMatrice...
                (mea, iScaleSegmentSize, iCorrelationWindow, iTrialLength, fs);
            folderWiseResult{fi}{regI,1}{1} = CorrConnectivityMatrix;
            folderWiseResult{fi}{regI,1}{2} = LagConnectivitymatrix;
        end
        disp("******processed folder: "+fi+ " MEA: "+regI+"******")
    end
    cd('../..')
end
