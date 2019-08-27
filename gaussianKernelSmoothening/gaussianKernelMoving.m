function [ gaussSpikeData] = gaussianKernelMoving(spikeData, gaussWidth, fs)
%Moving average bteween Gaussian Kernel of gaussWidth of spikeData

gaussKernel = gausswin(gaussWidth*fs);
gaussSpikeData = conv(sign(full(spikeData)), gaussKernel );
gaussSpikeData = gaussSpikeData (ceil(length(gaussKernel )/2):end-floor(length(gaussKernel)/2));
end

