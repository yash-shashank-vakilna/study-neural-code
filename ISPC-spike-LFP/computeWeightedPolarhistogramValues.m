function [ histcounts, binedges] = computeWeightedPolarhistogramValues ( peak_train, LFP_train, nbins )
%for all the angles corresponding to non-zero values of peak train, the
%code extracts angle series using hilbert transform 

angleS = angle(hilbert(LFP_train));

% weightedspikeAngleDistro = angleS.*sign(peak_train).*LFP_train;
% weightedspikeAngleDistro( weightedspikeAngleDistro == 0) = [];
% weightedspikeAngleDistro = full(weightedspikeAngleDistro);
weightedspikeAngleDistro = []; spikeAngleDistro = [];
spikeIndex = find(peak_train);
for sfi = 1:length(spikeIndex)
    weightedspikeAngleDistro = [weightedspikeAngleDistro, ...
        repmat(angleS(spikeIndex(sfi)),1,round(10*abs(LFP_train(spikeIndex(sfi)))))];
    spikeAngleDistro = [spikeAngleDistro, angleS(spikeIndex(sfi))];
end
p=polarhistogram(weightedspikeAngleDistro,nbins,'visible','off');
histcounts = round(p.BinCounts./10);
binedges = p.BinEdges;



end

