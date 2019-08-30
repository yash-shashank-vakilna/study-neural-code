function [ histcounts] = computeWeightedPolarhistogramValues ( peak_train, LFP_train, nbins , powerWeight)
%for all the angles corresponding to non-zero values of peak train, the
%code extracts angle series using hilbert transform 

angleS = angle(hilbert(LFP_train));

weightedspikeAngleDistro = [];
histcounts = []; 
spikeIndex = find(peak_train);
for sfi = 1:length(spikeIndex)
    weightedspikeAngleDistro = [weightedspikeAngleDistro, ...
        repmat(angleS(spikeIndex(sfi)),1,round(powerWeight*abs(LFP_train(spikeIndex(sfi)))))];
end
if not(isempty(spikeIndex))
    binedges = linspace(-pi,pi,nbins+1);
    p = polarhistogram(weightedspikeAngleDistro,'binEdges', binedges,'visible','off');
    histcounts = round(p.BinCounts./powerWeight);
end

end

